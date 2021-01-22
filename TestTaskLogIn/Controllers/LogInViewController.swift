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
    @IBOutlet weak var passwordError: UILabel!
    
    var authManager: AuthenticationManagerProtocol?
    let valid = String.ValidityType.email
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authManager?.delegate = self
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
        let vc = storyboard.instantiateViewController(withIdentifier: "LogOutTabBarController") as! UITabBarController
        present(vc, animated: true, completion: nil)
    }
    
    private func setupTextField() {
        emailTF.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    }
    
    @objc private func handleTextChange() {
        guard let emailText = emailTF.text,
              let passwordText = passwordTF.text else { return }
        
        let isEmailValid = emailText.isValid(.email)
        let isPasswordValid = passwordText.isValid(.password)
        
        passwordError.isHidden = isPasswordValid
        
        if !isEmailValid || !isPasswordValid {
            signInButton.alpha = 0.5
            signInButton.isUserInteractionEnabled = false
        } else {
            signInButton.alpha = 1.0
            signInButton.isUserInteractionEnabled = true
        }
    }
}

//MARK: - AuthenticationManagerDelegate
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
