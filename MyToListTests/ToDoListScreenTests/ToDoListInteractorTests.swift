//
//  ToDoListInteractorTests.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//

import XCTest
@testable import MyToList

final class ToDoListInteractorTests: XCTestCase {
    
    var interactor: ToDoListInteractor?
    var mockPresenter: MockToDoListPresenter?
    var mockToDoListStorage: MockToDoListStorage?
    

    override func setUp() {
        super.setUp()
        mockPresenter = MockToDoListPresenter()
        mockToDoListStorage = MockToDoListStorage()
        interactor = ToDoListInteractor(coreDataManager: CoreDataManager(), networkService: NetworkService())
    }
    
    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockToDoListStorage = nil
        super.tearDown()
    }

    func testSwitchToDoItemCompleteState_UpdatesToDoItem() {
        let item = ToDoListItemConstants.defaultToDoListItem
        let indexPath = IndexPath(row: 0, section: 0)
        interactor?.checkmarkToDoItem(at: indexPath) { _ in 
            XCTAssertEqual(self.mockToDoListStorage?.updatedTodo, item)
        }
    }
}
