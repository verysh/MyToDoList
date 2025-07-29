//
//  ToDoListViewControllerTests.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//

import XCTest
@testable import MyToList

final class ToDoListViewControllerTests: XCTestCase {
    var view: ToDoListViewController?
    var mockPresenter: MockToDoListPresenter?
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockToDoListPresenter()
        view = ToDoListViewController(presenter: mockPresenter)
        view?.loadViewIfNeeded()
    }
    
    override func tearDown() {
        view = nil
        mockPresenter = nil
        super.tearDown()
    }
    
    func testViewDidLoad_CallsPresenterViewDidLoad() throws {
        guard let mockPresenter else { return }
        mockPresenter.viewDidLoad()
        XCTAssertTrue(mockPresenter.didReloadData, "Expected didReloadData to be true, but it was not.")
    }
}
