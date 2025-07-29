//
//  ToDoItem.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 21.07.2025.
//

import Foundation

struct ToDoItem: Identifiable, Equatable  {
    let id: UUID
    let title: String
    let completed: Bool
    let taskDescription: String?
    let createdAt: Date
}

enum ToDoListItemConstants {
    static let defaultToDoListItem = ToDoItem(id: UUID(),
                                      title: "Default title",
                                      completed: false,
                                      taskDescription: "Default descrtiption",
                                      createdAt: Date())
                                      
    static let newToDoListItem = ToDoItem(id: UUID(),
                                          title: "Новая задача",
                                          completed: false,
                                          taskDescription: "Добавьте описание задачи", createdAt: Date())
}
