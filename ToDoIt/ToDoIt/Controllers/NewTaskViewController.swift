//
//  NewTaskViewController.swift
//  ToDoIt
//
//  Created by Ivan Tyurin on 22.06.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var placeField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    private let dataManager = DataModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addBtnPressed(_ sender: UIButton) {
        guard let titleText = titleField.text else { return }
        guard let descriptionText = descriptionField.text else { return }
        guard let placeText = placeField.text else { return }
        let deadLine = datePicker.date
        dataManager.addTask(title: titleText, text: descriptionText, place: placeText, deadLine: deadLine)
        dismiss(animated: true, completion: nil)
    }
}
