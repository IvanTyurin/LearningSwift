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
    private let context: NSManagedObjectContext
    private var tasks: [NSManagedObject] = []
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoIt")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("CoreData container error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    static var shared = DataModel()

    private init() {
        context = persistentContainer.viewContext
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

    func editTask(editedTask: TaskStruct) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TasksData")
        fetchRequest.predicate = NSPredicate(format: "id = %@", editedTask.id as CVarArg)

        do {
            let task = try context.fetch(fetchRequest)

            if let updateTask = task.first {
                updateTask.setValuesForKeys(["title": editedTask.title,
                                             "text": editedTask.text,
                                             "place": editedTask.place,
                                             "deadLine": editedTask.deadLine,
                                             "classifier": editedTask.classifier])

                do {
                    try context.save()
                } catch let error as NSError {
                    print("Saving Error! \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Fetch Error! \(error), \(error.userInfo)")
        }
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

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                return
            }
        }
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
