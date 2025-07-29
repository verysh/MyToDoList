//
//  MockToDoItemPresenter.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//

import Foundation
@testable import MyToList

final class MockToDoItemPresenter {
    
    var showDataCalled = false
    var didFinishEditingCalled = false
    var dismissCalled = false

}

extension MockToDoItemPresenter: ToDoItemDetailPresenterProtocol {
    func showData() {
        showDataCalled = true
    }
    func endEditing(title: String?, text: String?) {
        didFinishEditingCalled = true
    }
    func dismiss() {
        dismissCalled = true
    }
}
