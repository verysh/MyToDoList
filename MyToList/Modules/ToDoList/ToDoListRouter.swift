//
//  ToDoListRouter.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 21.07.2025.
//

import UIKit
import Foundation

protocol ToDoListRouterProtocol: AnyObject {
    static func createStartModule() -> UIViewController
    func navigateToDetailEditItem(_ item: ToDoItem,
                                  isNewTask: Bool,
                                  indexPath: IndexPath?,
                                  onTaskCreated: @escaping () -> Void,
                                  onTaskUpdated: @escaping () -> Void)
}

final class ToDoListRouter: ToDoListRouterProtocol {

    weak var viewController: UIViewController?

    static func createStartModule() -> UIViewController {
        
        let view = ToDoListViewController()
        let coreDataManager = CoreDataManager()
        let networkService = NetworkService()
        let interactor = ToDoListInteractor(coreDataManager: coreDataManager, networkService: networkService)
        let router = ToDoListRouter()
        let presenter = ToDoListPresenter(view: view,
                                          interactor: interactor,
                                          router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateToDetailEditItem(_ item: ToDoItem,
                                  isNewTask: Bool,
                                  indexPath: IndexPath?,
                                  onTaskCreated: @escaping () -> Void,
                                  onTaskUpdated: @escaping () -> Void) {
        
        let viewDetailEditVC = ToDoItemDetailRouter.buildConfigurator(
            item,
            isNewTask: isNewTask,
            indexPath: indexPath,
            onTaskCreated: onTaskCreated,
            onTaskUpdated: onTaskUpdated)
        
        viewController?.navigationController?.pushViewController(viewDetailEditVC, animated: true)
    }
    
}
