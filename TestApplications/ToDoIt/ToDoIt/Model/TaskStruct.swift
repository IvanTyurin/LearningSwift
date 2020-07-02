//
//  TaskStruct.swift
//  ToDoIt
//
//  Created by Ivan Tyurin on 02.07.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import Foundation

struct TaskStruct {
    let id: UUID
    let title: String
    let text: String
    let place: String
    let classifier: String
    let creationDate: Date
    let deadLine: Date
    let endDate: Date?
    let status: Bool
}
