//
//  ToDoItemDetailPresenterTests.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//

import XCTest
@testable import MyToList

final class ToDoItemDetailPresenterTests: XCTestCase {

    private var presenter: ToDoItemDetailPresenter?
    private var mockView: MockToDoItemDetailViewController?
    private var mockInteractor: MockToDoItemDetailInteractor?
    private var mockRouter: MockToDoItemDetailRouter?
    private var toDoItem: ToDoItem?
    
    override func setUp() {
        super.setUp()
        toDoItem = ToDoItem(id: UUID(), title: "Test text", completed: false, taskDescription: nil, createdAt: Date())
        mockView = MockToDoItemDetailViewController()
        mockInteractor = MockToDoItemDetailInteractor()
        mockRouter = MockToDoItemDetailRouter()
        
        guard let toDoItem, let mockView, let mockInteractor,
                let mockRouter else { return }

        presenter = ToDoItemDetailPresenter(
            view: mockView,
            interactor: mockInteractor,
            router: mockRouter,
            toDoItem: toDoItem,
            isNewTask: true,
            onTaskCreated: nil,
            onTaskUpdated: nil
        )
    }
    
    func testFetchData_DisplaysToDoItemsList() {
        guard let presenter, let mockView, let toDoItem else {return}
        presenter.showData()
        XCTAssertEqual(mockView.displayedTitle, toDoItem.title)
        XCTAssertEqual(mockView.displayedTaskDescription, toDoItem.taskDescription)
        XCTAssertEqual(mockView.displayedDate, toDoItem.createdAt.toString())
    }
    
    func testDidFinishEditing_CreatesNew_WhenIsNewTaskTrue() {
        guard let presenter, let mockInteractor else {return}
        presenter.endEditing(title: "Test string", text: "Test string")
        XCTAssertTrue(mockInteractor.createTaskCalled)
    }
    
    func testDismiss_CallsRouterDismiss() {
        guard let presenter, let mockRouter else {return}
        presenter.dismiss()
        XCTAssertTrue(mockRouter.dismissCalled)
    }
    
}
