//
//  ToDoListPresenterTests.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//

import XCTest
@testable import MyToList

final class ToDoListPresenterTests: XCTestCase {

    var presenter: ToDoListPresenter!
    var mockView: MockToDoListViewController!
    var mockInteractor: MockToDoListInteractor!
    var mockRouter: MockToDoListRouter!
    
    override func setUp() {
        super.setUp()
        mockView = MockToDoListViewController()
        mockInteractor = MockToDoListInteractor()
        mockRouter = MockToDoListRouter()
        presenter = ToDoListPresenter(view: mockView,
                                      interactor: mockInteractor,
                                      router: mockRouter)
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    
    func testViewDidLoadCallsFetchTodos() {
        
        presenter.fetchToDoList()
        XCTAssertTrue(mockInteractor.fetchTodosCalled)
    }
    
    func testDidSelectTodo_CallsNavigateToDetail() {
        
        let toDoItem = ToDoItem(id: UUID(), title: "Test Task",  completed: false, taskDescription: "", createdAt: Date())
        
        mockRouter.navigateToDetailEditItem(toDoItem,
                                            isNewTask: false,
                                            indexPath: nil,
                                            onTaskCreated: { },
                                            onTaskUpdated: { })
        
        XCTAssertTrue(mockRouter.navigateToDetailCalled)
        XCTAssertEqual(mockRouter.selectedToDoItem, toDoItem)
    }
    
    func testShowToDoItems_CallsViewShowToDoItems() {
        
        let toDoItems = [ToDoItem(id: UUID(), title: "Test Task",  completed: false, taskDescription: "", createdAt: Date())]

        mockView.showToDoItems(toDoItems)
        
        XCTAssertTrue(mockView.showToDoItemsCalled)
        XCTAssertEqual(mockView.toDoItemsShown, toDoItems)
    }
}
