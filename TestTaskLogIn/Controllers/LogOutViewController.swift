//
//  LogOutViewController.swift
//  TestTaskLogIn
//
//  Created by Виталий on 21.01.2021.
//

import UIKit

class LogOutViewController: UIViewController {

    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        let keyChain = KeychainSwift()
        keyChain.delete("userToken")
        self.dismiss(animated: true, completion: nil)
    }
}
