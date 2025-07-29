//
//  MockToDoItemDetailViewController.swift
//  MyToListTests
//
//  Created by Vladimir Eryshev on 26.07.2025.
//

import Foundation
import UIKit
@testable import MyToList

final class MockToDoItemDetailViewController: UIViewController {
    var displayedTitle: String?
    var displayedDate: String?
    var displayedTaskDescription: String?
    
}

extension MockToDoItemDetailViewController: ToDoItemDetailViewProtocol {
    func displayDataItem(title: String, date: String, text: String?) {
        displayedTitle = title
        displayedDate = date
        displayedTaskDescription = text
    }
}
