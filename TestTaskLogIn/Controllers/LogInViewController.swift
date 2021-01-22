//
//  LogInViewController.swift
//  TestTaskLogIn
//
//  Created by Виталий on 21.01.2021.
//

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var authManager: AuthenticationManagerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authManager?.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        setupTextField()
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        signIn()
        
    }
    
    private func signIn() {
        guard let email = emailTF.text, let password = passwordTF.text else { return }
        authManager?.logIn(with: email, password: password)
    }
    
    private func transition() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LogOutViewController") as! LogOutViewController
        present(vc, animated: true, completion: nil)
    }
    
    private func setupTextField() {
        emailTF.addTarget(self, action: #selector(handleTextChangeEmail), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(handleTextChangeEmail), for: .editingChanged)
    }
    
    @objc private func handleTextChangeEmail() {
        guard let emailText = emailTF.text, let passwordText = passwordTF.text else { return }
        print(emailText)
        
        if emailText.isValid(.email) {
            print("Valid email")
        } else {
            print("Not valid")
        }
        
        if passwordText.isValid(.password) {
            print("Valid password")
        } else {
            print("Not valid password")
        }
    }
}

extension LogInViewController: AuthenticationManagerDelegate {
    func didGetUser(_ user: UserDataModel) {
        transition()
    }
    
    
    func didFailWithError(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
