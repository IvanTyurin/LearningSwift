//
//  DetailViewController.swift
//  ToDoIt
//
//  Created by Ivan Tyurin on 23.06.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension DetailViewController: TaskDetailViewDelegate {
    func selectedTask(_ task: [String : Any?]) {
        print("Task Detail View \(task["id"])")
    }
}


