//
//  ListViewController.swift
//  MyToDoList
//
//  Created by admin on 17.10.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Propertyes
    var user: UserModel!
    var ref: DatabaseReference!
    var tasks = [Task]()
    private let tableNibName = "ListTableViewCell"
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        configUserDataBase()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        ref.observe(.value) { [weak self] (snapshot) in
            var tasks = [Task]()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                tasks.append(task)
            }
            self?.tasks = tasks
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
    
    //MARK: - IBAction
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New Task", message: "Add new task", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else {
                return
                //Суда можно добавить проверку и сообщение юзеру что вышла ошибка и т.д.
            }
            let task = Task.init(title: textField.text!, userId: (self?.user.uid)!)
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(task.convertToDictionary())
        }
        let cancel = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        do {
           try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - private functions
    private func config() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: tableNibName, bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseId)
        let titleNavigation = "Tasks"
        self.navigationItem.title = titleNavigation
    }
    
    private func configUserDataBase() {
        guard let cuurentUser = Auth.auth().currentUser else { return }
        user = UserModel(user: cuurentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
    }
    
    private func checkmarkComletion(_ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
}

//MARK: - UITableViewDataSource UITableViewDelegate
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseId, for: indexPath) as? ListTableViewCell
        guard let cell = listCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        let taskTitle = task.title
        let taskCompleted = task.completed
        cell.configure(title: taskTitle)
        checkmarkComletion(cell, isCompleted: taskCompleted)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        
        checkmarkComletion(cell, isCompleted: isCompleted)
        task.ref?.updateChildValues(["completed" : isCompleted])
    }
}
