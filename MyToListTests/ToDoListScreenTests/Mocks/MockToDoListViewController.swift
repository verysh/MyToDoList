//
//  MockToDoListViewController.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//

import UIKit
import Foundation

@testable import MyToList

final class MockToDoListViewController: UIViewController {
    
    var showToDoItemsCalled = false
    var toDoItemsShown: [ToDoItem] = []
    
    var didReloadData = false
    var footerText: String?
    
    func reloadData() {
        didReloadData = true
    }
}

extension MockToDoListViewController: ToDoListViewProtocol {
    func reloadRow(at indexPath: IndexPath, updatedItems: [MyToList.ToDoItem]) { }
    func updateSearchItems(_ items: [MyToList.ToDoItem]) { }
   
    func showToDoItems(_ items: [MyToList.ToDoItem]) {
        showToDoItemsCalled = true
        toDoItemsShown = items
    }
    
    func showError(error: any Error) { }
    func deteleteRow(at indexPath: IndexPath, updatedItems: [MyToList.ToDoItem]) { }
}
