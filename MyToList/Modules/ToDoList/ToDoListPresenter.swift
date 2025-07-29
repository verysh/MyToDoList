//
//  ToDoListPresenter.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 21.07.2025.
//

import Foundation

protocol ToDoListPresenterProtocol: AnyObject {
    func fetchToDoList()
    func showToDoItems(_ items: [ToDoItem])
    func searchToDoItemBy(_ title: String)
    func searchToDoItemCancel()
    func removeToDoItem(at indexPath: IndexPath)
    func checkmarkToDoItem(at indexPath: IndexPath)
    func showError(error: Error)
    func detailToDoItemEdit(for item: ToDoItem, isNewTask: Bool, indexPath: IndexPath?)
}

final class ToDoListPresenter {
    weak var view: ToDoListViewProtocol?
    var interactor: ToDoListInteractorProtocol
    var router: ToDoListRouterProtocol

    init(view: ToDoListViewProtocol, interactor: ToDoListInteractorProtocol, router: ToDoListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension ToDoListPresenter: ToDoListPresenterProtocol {
  
    func fetchToDoList() {
        interactor.fetchToDoList()
    }
    
    func showToDoItems(_ items: [ToDoItem]) {
        view?.showToDoItems(items)
    }
    
    func checkmarkToDoItem(at indexPath: IndexPath) {
        interactor.checkmarkToDoItem(at: indexPath) { [weak self] list in
            guard let self else { return }
            self.view?.reloadRow(at: indexPath,
                                 updatedItems: list)
        }
    }
    
    func searchToDoItemBy(_ title: String) {
        interactor.searchToDoItemBy(title) { [weak self] searchResults in
            self?.view?.updateSearchItems(searchResults)
        }
    }
    
    func searchToDoItemCancel() {
        interactor.searchToDoItemCancel { [weak self] in
            guard let self else { return }
            self.view?.updateSearchItems(self.fetchUpdatedToDoListItem())
        }
    }
    
    func removeToDoItem(at indexPath: IndexPath) {
        interactor.removeToDoItem(at: indexPath) { [weak self] in
            guard let self else { return }
            self.view?.showToDoItems(self.fetchUpdatedToDoListItem())
        }
    }
    
    func detailToDoItemEdit(for item: ToDoItem, isNewTask: Bool, indexPath: IndexPath?) {
        router.navigateToDetailEditItem(
            item,
            isNewTask: isNewTask,
            indexPath: indexPath,
            onTaskCreated: { [weak self] in
                guard let self else { return }
                self.view?.showToDoItems(self.fetchUpdatedToDoListItem())
            },
            onTaskUpdated: { [weak self]  in
                guard let indexPath = indexPath, let self else { return }
                self.view?.reloadRow(at: indexPath,
                                     updatedItems: self.fetchUpdatedToDoListItem())
            })
    }
    
    func showError(error: Error) {
        view?.showError(error: error)
    }
}

private extension ToDoListPresenter {
    func fetchUpdatedToDoListItem() -> [ToDoItem] {
        interactor.fetchCurrentLocalToDoListItems()
    }
}

enum TextConstants {
    static let edit = "Редактировать"
    static let share = "Поделиться"
    static let remove = "Удалить"
    static let footerText = "задач"
    static let title = "Задачи"
    static let searchBarPlaceholder = "Search"
    static let back = "Назад"
}
