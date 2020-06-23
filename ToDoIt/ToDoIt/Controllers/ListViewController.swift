//
//  ListViewController.swift
//  ToDoIt
//
//  Created by Ivan Tyurin on 22.06.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    private var dataManager = DataModel.shared
    private var tasksArray: [[String: Any?]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.tintColor = .darkGray
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        tasksArray = dataManager.getArray()
        tableView.reloadData()
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListViewCell
        else { return UITableViewCell() }
        let task = tasksArray[indexPath.row]
        let state = task["status"] as! Bool
        let title = task["title"] as? String
        let currentDate = Date()
        let deadLine = task["deadLine"] as! Date
        let calendar = Calendar.current.dateComponents([.hour, .day, .weekOfYear, .month], from: currentDate, to: deadLine)
        let deadLineString = "\(calendar.hour ?? 0) hours remaining"

        cell.checkBox.tag = indexPath.row
        cell.checkBox.addTarget(self, action: #selector(checkBoxBtnPressed), for: .touchUpInside)
        cell.titleLabel.text = title
        cell.deadLineLabel.text = deadLineString

        if state {
            cell.checkBox.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            cell.checkBox.tintColor = .darkGray
        } else {
            cell.checkBox.setImage(UIImage(systemName: "circle"), for: .normal)
            cell.checkBox.tintColor = .systemGray3
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasksArray[indexPath.row]
            let uuid = task["id"] as! UUID
            dataManager.deleteTask(uuid: uuid)
            tasksArray = dataManager.getArray()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    @objc private func checkBoxBtnPressed(sender: UIButton) {
        stateChange(sender.tag)
        print("Recive: ", sender.tag)
    }

    private func stateChange(_ index: Int) {
        let indx = IndexPath(row: index, section: 0)
        let box = (tableView.cellForRow(at: indx) as? ListViewCell)?.checkBox
        let task = tasksArray[index]
        let id = task["id"] as! UUID

        dataManager.changeStatus(uuid: id)
        if box?.imageView?.image == UIImage(systemName: "circle") {
            box?.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            box?.tintColor = .darkGray
        } else {
            box?.setImage(UIImage(systemName: "circle"), for: .normal)
            box?.tintColor = .systemGray3
        }
    }
}
