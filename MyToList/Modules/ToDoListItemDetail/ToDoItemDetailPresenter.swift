//
//  ToDoItemDetailPresenter.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 21.07.2025.
//

import Foundation

protocol ToDoItemDetailPresenterProtocol {
    func showData()
    func endEditing(title: String?, text: String?)
    func dismiss()
}

final class ToDoItemDetailPresenter {

    // MARK: - Private Properties
    private weak var view: ToDoItemDetailViewProtocol?
    private let interactor: ToDoItemDetailInteractorProtocol
    private let router: ToDoItemDetailRouterProtocol
    private let toDoItem: ToDoItem
    private let isNewTask: Bool
    private let onTaskCreated: (() -> Void)?
    private let onTaskUpdated: (() -> Void)?
    
    // MARK: - Initializers
    init(
        view: ToDoItemDetailViewProtocol,
        interactor: ToDoItemDetailInteractorProtocol,
        router: ToDoItemDetailRouterProtocol,
        toDoItem: ToDoItem,
        isNewTask: Bool,
        onTaskCreated: (() -> Void)?,
        onTaskUpdated: (() -> Void)?
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.toDoItem = toDoItem
        self.isNewTask = isNewTask
        self.onTaskCreated = onTaskCreated
        self.onTaskUpdated = onTaskUpdated
    }
}

extension ToDoItemDetailPresenter: ToDoItemDetailPresenterProtocol {
    
    func showData() {
        view?.displayDataItem(title: toDoItem.title,
                              date: toDoItem.createdAt.toString(),
                              text: toDoItem.taskDescription)
    }
    
    func endEditing(title: String?, text: String?) {
        guard let title = title, !title.isEmpty else {
            print("Title is empty, task not saved")
            return
        }
        
        DispatchQueue.global().async {
            self.handleEditCreateTask(title: title, text: text)
        }
    }
    
    func dismiss() {
        router.dismiss()
    }
}

private extension ToDoItemDetailPresenter {
    func handleEditCreateTask(title: String, text: String?) {
        if isNewTask {
            interactor.createTask(title: title, text: text) { [weak self] in
                self?.onTaskCreated?()
            }
        } else {
            interactor.updateTask(title: title, text: text) { [weak self]  in
                self?.onTaskUpdated?()
            }
        }
    }
}
