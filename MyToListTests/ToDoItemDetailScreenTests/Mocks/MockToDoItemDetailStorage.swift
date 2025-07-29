//
//  MockToDoItemDetailStorage.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 27.07.2025.
//

import Foundation
@testable import MyToList

final class MockToDoItemDetailStorage {
    
    var addToDoItemCalled = false
    var updateToDoItemCalled = false

    func createToDoItem(_ item: ToDoItem, completion: (() -> Void)? = nil) {
        addToDoItemCalled = true
        completion?()
    }

    func updateToDoItem(_ item: ToDoItem, completion: (() -> Void)? = nil) {
        updateToDoItemCalled = true
        completion?()
    }
}
