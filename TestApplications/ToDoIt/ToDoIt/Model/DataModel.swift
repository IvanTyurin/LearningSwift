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
    private let defaults = UserDefaults.standard
    private let uploadKey = "TaskDataChanged"
    private let db = Firestore.firestore()

    private var timer = Timer()
    private var tasks: [NSManagedObject] = []
    private var array: [TaskStruct] = []
    private var user: User?
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
        if defaults.value(forKey: uploadKey) == nil {
            defaults.set(true, forKey: uploadKey)
        }
        context = persistentContainer.viewContext
        loadData()
        createTimer()
    }

    func loadData() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TasksData")

        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Fetch Error! \(error), \(error.userInfo)")
        }
    }

    func getArray(level: Int) -> ([TaskStruct]) {
        if !tasks.isEmpty {
            array = []
            let currentDate = Date()

            for task in tasks {
                let deadLine = task.value(forKey: "deadLine") as! Date
                let calendar = Calendar.current.dateComponents([.hour, .day, .weekOfYear, .month], from: currentDate, to: deadLine)

                if level == 3 {
                    let deadLineString = "\(calendar.weekOfYear ?? 0) weeks \(calendar.day ?? 0) days \(calendar.hour ?? 0) hours remaining"
                    appendTaskToArray(task, deadLineString)
                }
                if let week = calendar.weekOfYear, let hour = calendar.hour, week == 0, hour >= 0, level == 2 {
                    let deadLineString = "\(calendar.day ?? 0) days \(calendar.hour ?? 0) hours remaining"
                    appendTaskToArray(task, deadLineString)
                }
                if let day = calendar.day, day == 1, level == 1 {
                    let deadLineString = "\(calendar.hour ?? 0) hours remaining"
                    appendTaskToArray(task, deadLineString)
                }
                if let day = calendar.day, day < 1, level == 0 {
                    let deadLineString = "\(calendar.hour ?? 0) hours remaining"
                    appendTaskToArray(task, deadLineString)
                }
            }
        } else {
            firebaseDataDownload()
        }

        array.sort { t1, t2 in
            (t1.classifier, t1.deadLine) < (t2.classifier, t2.deadLine)
        }
        return array
    }

    private func appendTaskToArray(_ task: NSManagedObject, _ deadLineString: String) {
        array.append(TaskStruct(id: task.value(forKey: "id") as! UUID,
                                title: task.value(forKey: "title") as! String,
                                text: task.value(forKey: "text") as! String,
                                place: task.value(forKey: "place") as! String,
                                classifier: task.value(forKey: "classifier") as! String,
                                creationDate: task.value(forKey: "creationDate") as! Date,
                                deadLine: task.value(forKey: "deadLine") as! Date,
                                endDate: task.value(forKey: "endDate") as? Date,
                                status: task.value(forKey: "status") as! Bool,
                                deadLineString: deadLineString))
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
        defaults.set(true, forKey: uploadKey)
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

        defaults.set(true, forKey: uploadKey)
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
                print("Status Changed")
            }
        }

        do {
            try context.save()
        } catch let error as NSError {
            print("Saving Error! \(error), \(error.userInfo)")
        }

        defaults.set(true, forKey: uploadKey)
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

        firebaseDeleteTask(id: uuid)
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
        if Auth.auth().currentUser != nil {
            user = Auth.auth().currentUser
            return true
        }
        return false
    }

    private func firebaseDataDownload() {
        var tempTasksArray: [TaskStruct] = []
        if checkFirebaseAuth() {
            if let user = user {
                db.collection("users").document(user.uid).collection("tasks").getDocuments { (query, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {

                        for task in query!.documents {
                            tempTasksArray.append(TaskStruct(
                                id: UUID(uuidString: task.data()["id"] as! String)!,
                                title: task.data()["title"] as! String,
                                text: task.data()["text"] as! String,
                                place: task.data()["place"] as! String,
                                classifier: task.data()["classifier"] as! String,
                                creationDate: (task.data()["creationDate"] as! Timestamp).dateValue(),
                                deadLine: (task.data()["deadLine"] as! Timestamp).dateValue(),
                                endDate: task.data()["endDate"] as? Timestamp != nil ? (task.data()["endDate"] as! Timestamp).dateValue() : nil,
                                status: task.data()["status"] as! Bool,
                                deadLineString: ""
                            ))
                        }

                        if let entity = NSEntityDescription.entity(forEntityName: "TasksData", in: self.context) {
                            for task in tempTasksArray {
                                let new = NSManagedObject(entity: entity, insertInto: self.context)
                                new.setValuesForKeys(["id": task.id,
                                                      "title": task.title,
                                                      "text": task.text,
                                                      "place": task.place,
                                                      "creationDate": task.creationDate,
                                                      "deadLine": task.deadLine,
                                                      "classifier": task.classifier,
                                                      "endDate": task.endDate,
                                                      "status": task.status])
                                self.tasks.append(new)
                            }

                            do {
                                try self.context.save()
                            } catch let error as NSError {
                                print("Saving Error! \(error), \(error.userInfo)")
                            }
                        }
                    }

                    if !tempTasksArray.isEmpty {
                        self.array = tempTasksArray
                        print("FireBase Array", self.array)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FirebaseDataDownloaded"), object: nil)
                    }
                }
            }
        }
    }

    private func firebaseDeleteTask(id: UUID) {
        if let user = user {
            db.collection("users").document(user.uid).collection("tasks").document(id.uuidString).delete() { error in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
    }

    private func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(firebaseDataUpload), userInfo: nil, repeats: true)
    }

    @objc func firebaseDataUpload() {
        if checkFirebaseAuth() && defaults.bool(forKey: uploadKey) {
            if let user = user {
                for task in array {
                    let data = ["id": task.id.uuidString,
                                "title": task.title,
                                "text": task.text,
                                "place": task.place,
                                "classifier": task.classifier,
                                "creationDate": task.creationDate,
                                "deadLine": task.deadLine,
                                "endDate": task.endDate ?? 0,
                                "status": task.status] as [String : Any]

                    db.collection("users").document(user.uid).collection("tasks").document(task.id.uuidString).setData(data) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }

                defaults.set(false, forKey: uploadKey)
                print("Firebase Uploading")
            }
        }
    }
}
