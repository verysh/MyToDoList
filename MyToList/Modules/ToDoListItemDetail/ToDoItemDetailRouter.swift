//
//  ToDoItemDetailRouter.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 21.07.2025.
//

import Foundation
import UIKit

protocol ToDoItemDetailRouterProtocol {
    func dismiss()
}

protocol ToDoItemDetailBuildConfiguratorProtocol {
    static func buildConfigurator(
            _ item: ToDoItem,
            isNewTask: Bool,
            indexPath: IndexPath?,
            onTaskCreated: @escaping () -> Void,
            onTaskUpdated: @escaping () -> Void
        ) -> UIViewController
}

final class ToDoItemDetailRouter {
   
    private weak var viewController: UIViewController?
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension ToDoItemDetailRouter: ToDoItemDetailRouterProtocol {
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

extension ToDoItemDetailRouter: ToDoItemDetailBuildConfiguratorProtocol {
    static func buildConfigurator(_ item: ToDoItem,
                                  isNewTask: Bool,
                                  indexPath: IndexPath?,
                                  onTaskCreated: @escaping () -> Void,
                                  onTaskUpdated: @escaping () -> Void) -> UIViewController {
        
        let viewDetailEditVC = ToDoItemDetailViewController()
        let interactor = ToDoItemDetailInteractor(toDoItem: item,
                                                  isNewTask: isNewTask,
                                                  coreDataManager: CoreDataManager())
        let router = ToDoItemDetailRouter(viewController: viewDetailEditVC)
        let presenter = ToDoItemDetailPresenter(
            view: viewDetailEditVC,
            interactor: interactor,
            router: router,
            toDoItem: item,
            isNewTask: isNewTask,
            onTaskCreated: onTaskCreated,
            onTaskUpdated: onTaskUpdated)
        viewDetailEditVC.presenter = presenter
       
        return viewDetailEditVC
    }
}
