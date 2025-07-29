//
//  ToDoItemDetailInteractorTests.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//

import XCTest
@testable import MyToList

final class ToDoItemDetailInteractorTests: XCTestCase {
    private var interactor: ToDoItemDetailInteractor?
    private var toDoItem: ToDoItem?
    private var mockToDoItemStorage: MockToDoItemDetailStorage?
    
    override func setUp() {
        super.setUp()
        toDoItem = ToDoItem(id: UUID(), title: "Test text", completed: false, taskDescription: nil, createdAt: Date())
        mockToDoItemStorage = MockToDoItemDetailStorage()
        guard let toDoItem else { return }
        interactor = ToDoItemDetailInteractor(toDoItem: toDoItem,
                                              isNewTask: true,
                                              coreDataManager: CoreDataManager())
    }
    
    func testCreateTask_CallsAddToDoItemOnStorage() {
        guard let toDoItem = toDoItem,
        let mockToDoItemStorage = mockToDoItemStorage else {
            XCTFail("Interactor or MockTodoStore is nil")
            return
        }
        
        mockToDoItemStorage.createToDoItem(toDoItem) {
            XCTAssertTrue(mockToDoItemStorage.addToDoItemCalled, "addTodo should have been called on the store")
        }
    }
    
    func testUpdateTask_CallsUpdateToDoItemOnStorage() {
        guard let mockToDoItemStorage = mockToDoItemStorage,
              let toDoItem = toDoItem else {
            XCTFail("MockTodoStore or Todo is nil")
            return
        }
        interactor = ToDoItemDetailInteractor(toDoItem: toDoItem,
                                              isNewTask: false,
                                              coreDataManager: CoreDataManager())
        interactor?.updateTask(title: "Test string", text: "Test description") {
            XCTAssertTrue(mockToDoItemStorage.updateToDoItemCalled, "updateTodo should have been called on the store")
        }
    }
}
