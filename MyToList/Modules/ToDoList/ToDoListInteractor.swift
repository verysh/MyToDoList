//
//  ToDoListInteractor.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 21.07.2025.
//

import Foundation

protocol ToDoListInteractorProtocol: AnyObject {
    func fetchToDoList()
    func searchToDoItemBy(_ title: String, completion: @escaping (_ list: [ToDoItem]) -> Void)
    func searchToDoItemCancel(completion: @escaping () -> Void)
    func removeToDoItem(at indexPath: IndexPath, completion: @escaping () -> Void)
    func checkmarkToDoItem(at indexPath: IndexPath,
                           completion: @escaping (_ list: [ToDoItem]) -> Void)
    func fetchCurrentLocalToDoListItems() -> [ToDoItem]
}

final class ToDoListInteractor {
    
    weak var presenter: ToDoListPresenterProtocol?
    private let coreDataManager: CoreDataManager
    private let networkService: NetworkServiceProtocol

    init(coreDataManager: CoreDataManager, networkService: NetworkServiceProtocol) {
        self.coreDataManager = coreDataManager
        self.networkService = networkService
    }
}

extension ToDoListInteractor: ToDoListInteractorProtocol {
 
    func fetchToDoList() {
        
        let toDoListItems = coreDataManager.itemsToDoList
 
        if UserDefaults.standard.bool(forKey: Constants.launchKey) {
            presenter?.showToDoItems(toDoListItems)
        } else {
            downloadInitialData()
        }
        UserDefaults.standard.set(true, forKey: Constants.launchKey)
    }
    
    func searchToDoItemBy(_ title: String, completion: @escaping (_ list: [ToDoItem]) -> Void) {
        guard !title.isEmpty else {
            completion(fetchCurrentLocalToDoListItems())
            return
        }
        
        DispatchQueue.global().async {
            self.coreDataManager.searchToDoItemBy(title, completion: completion)
        }
    }
    
    func searchToDoItemCancel(completion: @escaping () -> Void) {
        completion()
    }

    func removeToDoItem(at indexPath: IndexPath, completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            self.coreDataManager.removeToDoItem(at: indexPath, completion: completion)
        }
    }
    
    func checkmarkToDoItem(at indexPath: IndexPath,
                           completion: @escaping (_ list: [ToDoItem]) -> Void) {
        DispatchQueue.global().async {
            self.coreDataManager.checkmarkToDoItem(at: indexPath,
                                                   completion: completion)
        }
    }
    
    func fetchCurrentLocalToDoListItems() -> [ToDoItem] {
        coreDataManager.itemsToDoList
    }
}

private extension ToDoListInteractor {
    func downloadInitialData() {
        networkService.fetchToDoItemList { [weak self] result in
            switch result {
            case .success(let fetchedTodos):
                self?.coreDataManager.saveLocallyToDoList(fetchedTodos)
                self?.fetchToDoList()
                
            case .failure(let error):
                self?.presenter?.showError(error: error)
            }
        }
    }
}
