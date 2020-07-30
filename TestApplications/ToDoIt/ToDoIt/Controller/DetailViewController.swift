//
//  DetailViewController.swift
//  ToDoIt
//
//  Created by Ivan Tyurin on 23.06.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!

    private var recievedTask: TaskStruct?
    private weak var editTaskDelegate: TaskDetailViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fillText()
    }

    private func fillText() {
        guard
            let title = recievedTask?.title,
            let text = recievedTask?.text,
            let place = recievedTask?.place,
            let deadLine = recievedTask?.deadLine
        else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm MMM d, YYYY"
        let formattedDeadLine = formatter.string(from: deadLine)

        titleLabel.text = title
        descriptionLabel.text = text
        placeLabel.text = place
        deadlineLabel.text = formattedDeadLine
    }

    @IBAction func closeBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func editBtnPressed(_ sender: UIButton) {
        guard let editVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditVC") as? EditViewController else { return }
        editTaskDelegate = editVC
        editVC.detailTaskDelegate = self
        if let task = recievedTask {
            editTaskDelegate?.selectedTask(task)
            navigationController?.pushViewController(editVC, animated: true)
        }
    }
}

extension DetailViewController: TaskDetailViewDelegate {
    func selectedTask(_ task: TaskStruct) {
        recievedTask = task
    }
}

