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
    private let tableNibName = "ListTableViewCell"
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
    }
    
    //MARK: - IBAction
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New Task", message: "Add new task", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else {
                return
                //Суда можно добавить проверку и сообщение юзеру что вышла ошибка и т.д.
            }
            
            //let task
            //taskRef
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
}

//MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseId, for: indexPath) as? ListTableViewCell
        guard let cell = listCell else {
            return UITableViewCell()
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    
}
