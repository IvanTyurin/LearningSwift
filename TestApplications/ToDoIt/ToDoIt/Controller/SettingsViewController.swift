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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupView()
    }

    private func setupView() {
        if Auth.auth().currentUser != nil {
            signOutButton.tintColor = UIColor(red: 148.0/255.0, green: 17.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            signOutButton.setTitle("Sign Out", for: .normal)
        } else {
            signOutButton.tintColor = .darkGray
            signOutButton.setTitle("Sign In", for: .normal)
        }
    }

    @IBAction func signOutBtnPressed(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch {
                print("Sign Out Success")
            }
            setupView()
            tabBarController?.selectedIndex = 0
        } else {
            if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "AuthViewController") as? AuthViewController {
                present(vc, animated: true, completion: nil)
                print("Done")
            }
            tabBarController?.selectedIndex = 0
        }
    }
}
