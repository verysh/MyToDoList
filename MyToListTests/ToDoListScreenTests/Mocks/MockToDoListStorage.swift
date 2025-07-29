//
//  MockToDoListStorage.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//

import Foundation
@testable import MyToList

final class MockToDoListStorage {
    var updatedTodo: ToDoItem?
    
    func updateTodo(_ todo: ToDoItem, completion: (() -> Void)? = nil) {
        updatedTodo = todo
        completion?()
    }
}
