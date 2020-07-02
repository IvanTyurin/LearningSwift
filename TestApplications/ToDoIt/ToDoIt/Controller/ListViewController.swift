//
//  ListViewController.swift
//  ToDoIt
//
//  Created by Ivan Tyurin on 22.06.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

protocol TaskDetailViewDelegate: class {
    func selectedTask(_ task: TaskStruct)
}

class ListViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    weak var taskDelegate: TaskDetailViewDelegate?

    private var dataManager = DataModel.shared
    private var tasksArray: [TaskStruct] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.tintColor = .darkGray
        if !dataManager.checkFirebaseAuth() {
            showAuthAlert()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: false)

        tasksArray = dataManager.getArray()
        tableView.reloadData()
    }

    private func showAuthAlert() {
        let alert = UIAlertController(title: "Create Account", message: "Please login or register", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "AuthViewController") as? AuthViewController {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(okButton)

        self.present(alert, animated: true, completion: nil)
        print("Alert Presented!")
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
        let state = task.status
        let title = task.title
        let priority = task.classifier
        let deadLine = task.deadLine
        let currentDate = Date()
        let calendar = Calendar.current.dateComponents([.hour, .day, .weekOfYear, .month], from: currentDate, to: deadLine)
        let deadLineString = "\(calendar.hour ?? 0) hours remaining"

        cell.checkBox.tag = indexPath.row
        cell.checkBox.addTarget(self, action: #selector(checkBoxBtnPressed), for: .touchUpInside)
        cell.titleLabel.text = title
        cell.deadLineLabel.text = deadLineString
        cell.priorityLabel.text = priority

        if state {
            cell.checkBox.setImage(UIImage(named: "checkedBox"), for: .normal)
            cell.checkBox.tintColor = .darkGray
        } else {
            cell.checkBox.setImage(UIImage(named: "uncheckedBox"), for: .normal)
            cell.checkBox.tintColor = .systemGray3
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasksArray[indexPath.row]
            let uuid = task.id
            dataManager.deleteTask(uuid: uuid)
            tasksArray = dataManager.getArray()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasksArray[indexPath.row]

        guard let detailVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController else { return }
        taskDelegate = detailVC
        taskDelegate?.selectedTask(task)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    @objc private func checkBoxBtnPressed(sender: UIButton) {
        stateChange(sender.tag)
        print("Recive: ", sender.tag)
    }

    private func stateChange(_ index: Int) {
        let indx = IndexPath(row: index, section: 0)
        let box = (tableView.cellForRow(at: indx) as? ListViewCell)?.checkBox
        let task = tasksArray[index]
        let id = task.id

        dataManager.changeStatus(uuid: id)
        if box?.imageView?.image == UIImage(named: "checkedBox") {
            box?.setImage(UIImage(named: "uncheckedBox"), for: .normal)
            box?.tintColor = .darkGray
        } else {
            box?.setImage(UIImage(named: "checkedBox"), for: .normal)
            box?.tintColor = .systemGray3
        }
    }
}