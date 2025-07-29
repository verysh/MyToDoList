//
//  MockToDoListRouter.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//
 
import Foundation
@testable import MyToList
import UIKit

final class MockToDoListRouter {
    
    var navigateToDetailCalled = false
    var selectedToDoItem: ToDoItem?
    
}

extension MockToDoListRouter: ToDoListRouterProtocol {
    static func createStartModule() -> UIViewController {
         UIViewController()
    }
    
    func navigateToDetailEditItem(_ item: MyToList.ToDoItem, isNewTask: Bool, indexPath: IndexPath?, onTaskCreated: @escaping () -> Void, onTaskUpdated: @escaping () -> Void) {
        navigateToDetailCalled = true
        selectedToDoItem = item
    }
}
