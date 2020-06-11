//
//  ViewController.swift
//  customAlertPermission
//
//  Created by Ivan Tyurin on 05.05.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        // Do any additional setup after loading the view.


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        CustomAlertPermission.shared.showIfNeeded(self)
    }
    
    @IBAction func pressed(_ sender: UIButton) {

    }

}

