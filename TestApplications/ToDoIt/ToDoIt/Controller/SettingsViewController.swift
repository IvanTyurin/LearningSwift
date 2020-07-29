//
//  SettingsViewController.swift
//  ToDoIt
//
//  Created by Ivan Tyurin on 28.07.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    @IBOutlet weak var signOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        if Auth.auth().currentUser != nil {
            signOutButton.tintColor = UIColor(red: 148.0/255.0, green: 17.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            signOutButton.isUserInteractionEnabled = true
        } else {
            signOutButton.tintColor = .lightGray
            signOutButton.isUserInteractionEnabled = false
        }
    }

    @IBAction func signOutBtnPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign Out Success")
        }
        setupView()
        tabBarController?.selectedIndex = 0
    }
}
