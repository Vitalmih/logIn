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
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        signIn()
        transition()
    }
    
    private func signIn() {
        guard let email = emailTF.text, let password = passwordTF.text else { return }
        authManager?.fetch(email: email, password: password)
    }
    
    private func transition() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LogOutViewController") as! LogOutViewController
        present(vc, animated: true, completion: nil)
    }
}

extension LogInViewController: AuthenticationManagerDelegate {
    
    func didFailWithError(error: Error) {
        //
        //        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        //        self.present(alert, animated: true, completion: nil)
        //        self.signInButton.isHighlighted = true
        //        self.signInButton.isEnabled = false
        
        print(error.localizedDescription)
    }
}
