//
//  MockToDoItemDetailInteractor.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//

import Foundation
@testable import MyToList

final class MockToDoItemDetailInteractor {
    
    var createTaskCalled = false
    var updateTaskCalled = false
   
}

extension MockToDoItemDetailInteractor: ToDoItemDetailInteractorProtocol {
    func createTask(title: String, text: String?, completion: @escaping () -> Void) {
        createTaskCalled = true
        completion()
    }
    
    func updateTask(title: String, text: String?, completion: @escaping () -> Void) {
        updateTaskCalled = true
        completion()
    } 
}
