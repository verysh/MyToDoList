//
//  MockToDoListInteractor.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//

import Foundation
@testable import MyToList

final class MockToDoListInteractor {
    
    var fetchTodosCalled = false
    var deleteTodoCalledWithTodo: ToDoItem?
   
}

extension MockToDoListInteractor: ToDoListInteractorProtocol {
    func checkmarkToDoItem(at indexPath: IndexPath, completion: @escaping ([MyToList.ToDoItem]) -> Void) { }
    
    func fetchToDoList() {
         fetchTodosCalled = true
    }
    
    func searchToDoItemBy(_ title: String, completion: @escaping ([MyToList.ToDoItem]) -> Void) { }
    func searchToDoItemCancel(completion: @escaping () -> Void) { }
    func removeToDoItem(at indexPath: IndexPath, completion: @escaping () -> Void) { }
    func fetchCurrentLocalToDoListItems() -> [MyToList.ToDoItem] {
       [ToDoItem(id: UUID(), title: "Test text", completed: false, taskDescription: nil, createdAt: Date())]
    }
    
    
}
