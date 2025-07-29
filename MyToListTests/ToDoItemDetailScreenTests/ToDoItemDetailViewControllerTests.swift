//
//  ToDoItemDetailViewControllerTests.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//

import XCTest
@testable import MyToList

final class ToDoItemDetailViewControllerTests: XCTestCase {
    
    private var viewController: ToDoItemDetailViewController?
    private var mockPresenter: MockToDoItemPresenter?

    override func setUp() {
        super.setUp()
        mockPresenter = MockToDoItemPresenter()
        viewController = ToDoItemDetailViewController()
        viewController?.presenter = mockPresenter
        _ = viewController?.view
    }

    func testFetchData_CallsPresenterFetchData() {
        guard let mockPresenter else { return }
        XCTAssertTrue(mockPresenter.showDataCalled)
    }

    func testViewWillDisappear_CallsPresenterDidFinishEditing() {
        guard let mockPresenter, let viewController else {return}
        viewController.viewWillDisappear(false)
        XCTAssertTrue(mockPresenter.didFinishEditingCalled)
    }
}
