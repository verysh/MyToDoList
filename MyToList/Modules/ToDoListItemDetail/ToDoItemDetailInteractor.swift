//
//  ToDoItemDetailInteractor.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 21.07.2025.
//

import Foundation

protocol ToDoItemDetailInteractorProtocol {
    func createTask(title: String, text: String?, completion: @escaping () -> Void)
    func updateTask(title: String, text: String?, completion: @escaping () -> Void)
}

final class ToDoItemDetailInteractor {

    // MARK: - Private Properties
    private let toDoItem: ToDoItem
    private let isNewTask: Bool
    private let coreDataManager: CoreDataManager
    
    // MARK: - Initializers
    init(toDoItem: ToDoItem, isNewTask: Bool, coreDataManager: CoreDataManager) {
        self.toDoItem = toDoItem
        self.isNewTask = isNewTask
        self.coreDataManager = coreDataManager
    }
}

extension ToDoItemDetailInteractor: ToDoItemDetailInteractorProtocol {
    func createTask(title: String, text: String?, completion: @escaping () -> Void) {
        let newToDoItem = ToDoItem(
            id: UUID(),
            title: title,
            completed: false,
            taskDescription: text,
            createdAt: Date()
        )
        coreDataManager.addToDoItem(newToDoItem) {
            completion()
        }
    }

    func updateTask(title: String, text: String?, completion: @escaping () -> Void) {
        let updatedTodo = ToDoItem(
            id: toDoItem.id,
            title: title,
            completed: toDoItem.completed,
            taskDescription: text,
            createdAt: toDoItem.createdAt
        )
        coreDataManager.editToDoItem(updatedTodo) { list in
            completion()
        }
    }
}
