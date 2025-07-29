//
//  MockToDoListPresenter.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//

import Foundation
@testable import MyToList

final class MockToDoListPresenter {
    var didReloadData: Bool = false
    
    func viewDidLoad() {
        didReloadData = true
    }
}

extension MockToDoListPresenter: ToDoListPresenterProtocol {
    func detailToDoItemEdit(for item: MyToList.ToDoItem, isNewTask: Bool, indexPath: IndexPath?) { }
    
    func fetchToDoList() {
        didReloadData = true
    }
    
    func showToDoItems(_ items: [MyToList.ToDoItem]) { }
    func searchToDoItemBy(_ title: String) { }
    func searchToDoItemCancel() { }
    func removeToDoItem(at indexPath: IndexPath) { }
    func checkmarkToDoItem(at indexPath: IndexPath) { }
    func showError(error: any Error) { }
}
