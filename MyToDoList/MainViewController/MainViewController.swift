//
//  ViewController.swift
//  MyToDoList
//
//  Created by admin on 17.10.2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet var warnLabel: UILabel!
    @IBOutlet var loginLabel: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    //MARK: - Propeties
    private let segueID = "tasksSegue"
    var ref: DatabaseReference!

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureKeyBoard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNotifications()
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotifications()
    }
    //MARK: - private functions
    private func configure() {
        scrollView.showsVerticalScrollIndicator = false
        passwordTextField.delegate = self
        emailTextField.delegate = self
        loginLabel.layer.cornerRadius = loginLabel.frame.width / 20
        loginLabel.layer.masksToBounds = true
        warnLabel.alpha = 0
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueID)!, sender: nil)
            }
        }
        
        ref = Database.database().reference(withPath: "users")
    }
    
    private func displayWarningLabel(withTetx text: String) {
        warnLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.warnLabel.alpha = 1
        }) { [weak self]complete in
            self?.warnLabel.alpha = 0
        }
    }
    //MARK: - func Notification
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: - Private Functions KeyBoard
    private func configureKeyBoard() {
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    @objc private func keyboardWasShown(notification: Notification) {
        guard let info = notification.userInfo as NSDictionary?,
            let keyBoardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)?.cgRectValue.size  else {
            return
        }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillBeHidden(notification: Notification) {
        scrollView?.contentInset = .zero
    }
    
    @objc private func hideKeyboard() {
        scrollView?.endEditing(true)
    }
    
    //MARK: - IBActions
    @IBAction func loginTappedButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withTetx: "информация не коректная ")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self]  (user, error) in
            if error != nil {
                self?.displayWarningLabel(withTetx: "Error occured")
                return
            }
            
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueID)!, sender: nil)
                return
            }
            
            self?.displayWarningLabel(withTetx: "нет такого пользавателя")
        }
        
    }
    
    @IBAction func registrTappedButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withTetx: "информация не коректная ")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            
            guard error == nil, user != nil else {
                self?.displayWarningLabel(withTetx: "оишбка")
                print(error!.localizedDescription)
                return
            }
            let userRef = self?.ref.child((user?.user.uid)!)
            userRef?.setValue(["email": user?.user.email])
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        scrollView?.endEditing(true)
        print("tap")
        return true
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

