//
//  EditViewController.swift
//  ToDoIt
//
//  Created by Ivan Tyurin on 07.07.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var prioritySegmenter: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!

    private var recievedTask: TaskStruct?
    weak var detailTaskDelegate: TaskDetailViewDelegate?
    private let dataModel = DataModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        fillData()
    }

    private func fillData() {
        if let task = recievedTask {
            titleTextField.text = task.title
            descriptionTextField.text = task.text
            placeTextField.text = task.place
            datePicker.setDate(task.deadLine, animated: true)
            switch task.classifier {
            case "A":
            prioritySegmenter.selectedSegmentIndex = 0
            case "B":
                prioritySegmenter.selectedSegmentIndex = 1
            case "C":
                prioritySegmenter.selectedSegmentIndex = 2
            case "D":
                prioritySegmenter.selectedSegmentIndex = 3
            default:
                prioritySegmenter.selectedSegmentIndex = 0
            }
        }
    }

    @IBAction func saveBtnPressed(_ sender: Any) {
        guard
            let titleText = titleTextField.text,
            let descriptionText = descriptionTextField.text,
            let placeText = placeTextField.text,
            let classifier = prioritySegmenter.titleForSegment(at: prioritySegmenter.selectedSegmentIndex),
            let task = recievedTask
        else { return }
        let deadLine = datePicker.date

        let editedTask = TaskStruct(id: task.id,
                                    title: titleText,
                                    text: descriptionText,
                                    place: placeText,
                                    classifier: classifier,
                                    creationDate: task.creationDate,
                                    deadLine: deadLine,
                                    endDate: task.endDate,
                                    status: task.status,
                                    deadLineString: "")

        dataModel.editTask(editedTask: editedTask)
        detailTaskDelegate?.selectedTask(editedTask)

        navigationController?.popViewController(animated: true)
    }
}

extension EditViewController: TaskDetailViewDelegate {
    func selectedTask(_ task: TaskStruct) {
        recievedTask = task
    }
}
