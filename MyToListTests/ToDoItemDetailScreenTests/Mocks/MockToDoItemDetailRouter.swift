//
//  MockToDoItemDetailRouter.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//

import Foundation
@testable import MyToList

final class MockToDoItemDetailRouter {

    var dismissCalled = false

}

extension MockToDoItemDetailRouter: ToDoItemDetailRouterProtocol {
    func dismiss() {
        dismissCalled = true
    }
}
