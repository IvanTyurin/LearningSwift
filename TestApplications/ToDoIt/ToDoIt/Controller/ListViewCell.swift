//
//  ListViewCell.swift
//  ToDoIt
//
//  Created by Ivan Tyurin on 22.06.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!

    func setData(data: TaskStruct) {
        let state = data.status
        let title = data.title
        let priority = data.classifier
        let deadLine = data.deadLine
        let currentDate = Date()
        let calendar = Calendar.current.dateComponents([.hour, .day, .weekOfYear, .month], from: currentDate, to: deadLine)
        let deadLineString = "\(calendar.hour ?? 0) hours remaining"

        titleLabel.text = title
        deadLineLabel.text = deadLineString
        priorityLabel.text = priority

        if state {
            checkBox.setImage(UIImage(named: "checkedBox"), for: .normal)
            checkBox.tintColor = .darkGray
        } else {
            checkBox.setImage(UIImage(named: "uncheckedBox"), for: .normal)
            checkBox.tintColor = .systemGray3
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.checkBox.setImage(UIImage(systemName: "circle"), for: .normal)
        checkBox.tintColor = .systemGray3
    }
}
