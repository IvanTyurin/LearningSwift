//
//  DataModel.swift
//  ToDoIt
//
//  Created by Ivan Tyurin on 22.06.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class DataModel {
    private let appDelegate: AppDelegate
    private let context: NSManagedObjectContext
    private var tasks: [NSManagedObject] = []

    static var shared = DataModel()

    private init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        loadData()
    }

    func loadData() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TasksData")

        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Fetch Error! \(error), \(error.userInfo)")
        }
        print(tasks)
    }

    func getArray() -> ([TaskStruct]) {
        var array: [TaskStruct] = []
        for task in tasks {
            array.append(TaskStruct(id: task.value(forKey: "id") as! UUID,
                        title: task.value(forKey: "title") as! String,
                        text: task.value(forKey: "text") as! String,
                        place: task.value(forKey: "place") as! String,
                        classifier: task.value(forKey: "classifier") as! String,
                        creationDate: task.value(forKey: "creationDate") as! Date,
                        deadLine: task.value(forKey: "deadLine") as! Date,
                        endDate: task.value(forKey: "endDate") as? Date,
                        status: task.value(forKey: "status") as! Bool))
        }

        array.sort { t1, t2 in
            (t1.classifier, t1.deadLine) < (t2.classifier, t2.deadLine)
        }
        return array
    }

    func addTask(title: String, text: String, place: String, deadLine: Date, classifier: String) {
        let currentDate = Date()
        let id = UUID()

        guard let entity = NSEntityDescription.entity(forEntityName: "TasksData", in: context) else { return }
        let task = NSManagedObject(entity: entity, insertInto: context)

        task.setValuesForKeys(["id": id,
                               "title": title,
                               "text": text,
                               "place": place,
                               "creationDate": currentDate,
                               "deadLine": deadLine,
                               "classifier": classifier])

        do {
            try context.save()
        } catch let error as NSError {
            print("Saving Error! \(error), \(error.userInfo)")
        }
        tasks.append(task)
        print("TaskSaved")
    }

    func changeStatus(uuid: UUID) {
        for task in tasks {
            if task.value(forKey: "id") as! UUID == uuid {
                let current = task.value(forKey: "status") as! Bool
                if !current {
                    task.setValue(Date(), forKey: "endDate")
                } else {
                    task.setValue(nil, forKey: "endDate")
                }
                task.setValue(!current, forKey: "status")
            }
        }

        do {
            try context.save()
        } catch let error as NSError {
            print("Saving Error! \(error), \(error.userInfo)")
        }
        print("Status Changed")
    }

    func deleteTask(uuid: UUID) {
        for task in tasks {
            if task.value(forKey: "id") as! UUID == uuid {
                context.delete(task)
                print("TaskDeleted")
            }
        }

        do {
            try context.save()
        } catch let error as NSError {
            print("Saving Error! \(error), \(error.userInfo)")
        }
        loadData()
    }

    // MARK: - Firebase segment
    func checkFirebaseAuth() -> Bool {
        if Auth.auth().currentUser == nil {
            return false
        }
        return true
    }

    func firebaseDataUpdate() {
        if checkFirebaseAuth() {
            
        }
    }
}
