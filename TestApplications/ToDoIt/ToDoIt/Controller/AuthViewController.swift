//
//  AuthViewController.swift
//  ToDoIt
//
//  Created by Ivan Tyurin on 26.06.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        interfaseSetup()
    }

    private func interfaseSetup() {
        let segmentState = segmentedControl.selectedSegmentIndex
        cancelButton.setTitle("Cancel", for: .normal)
        warningLabel.isHidden = true

        switch segmentState {
        case 0:
            okButton.setTitle("Log In", for: .normal)
            forgotButton.setTitle("Forgot your password?", for: .normal)
            forgotButton.isHidden = false
        case 1:
            okButton.setTitle("Sign Up", for: .normal)
            forgotButton.isHidden = true
        default:
            okButton.setTitle("Log In", for: .normal)
            forgotButton.setTitle("Forgot your password?", for: .normal)
            forgotButton.isHidden = false
        }
    }

    private func login() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }

        if email != "" && password != ""{
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
                guard let strongSelf = self else { return }
                if error != nil {
                    strongSelf.warningLabel.text = "Authentification error!"
                    strongSelf.warningLabel.isHidden = false
                }
            }
        } else {
            if email == "" {
                warningLabel.text = "E-mail field is empty!"
            }
            if password == "" {
                warningLabel.text = "Password field is empty!"
            }
            if email == "" && password == "" {
                warningLabel.text = "E-mail and Password fields are empty!"
            }
            warningLabel.isHidden = false
        }
    }

    private func signup() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }

        if email != "" && password != ""{
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
                guard let strongSelf = self else { return }
                if error != nil {
                    strongSelf.warningLabel.text = "Registration error!"
                    strongSelf.warningLabel.isHidden = false
                }
                if let _ = authResult?.user {
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            if email == "" {
                warningLabel.text = "E-mail field is empty!"
            }
            if password == "" {
                warningLabel.text = "Password field is empty!"
            }
            if email == "" && password == "" {
                warningLabel.text = "E-mail and Password fields are empty!"
            }
            warningLabel.isHidden = false
        }
    }

    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        interfaseSetup()
    }

    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func okBtnPressed(_ sender: UIButton) {
        let segmentState = segmentedControl.selectedSegmentIndex
        print(segmentState)
        if segmentState == 0 {
            login()
        } else if segmentState == 1 {
            signup()
        }
    }

    @IBAction func forgotBtnPressed(_ sender: UIButton) {

    }
}
