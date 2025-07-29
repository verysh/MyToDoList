//
//  CoreDataManager.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 21.07.2025.
//

import UIKit
import CoreData
import Foundation

protocol CoreDataManagerProtocol {
    func saveLocallyToDoList(_ toDoList: [ToDoDTO])
    func searchToDoItemBy(_ title: String,
                          completion: @escaping (_ list: [ToDoItem]) -> Void)
    func removeToDoItem(at indexPath: IndexPath,
                        completion: @escaping () -> Void)
    func editToDoItem(_ item: ToDoItem,
                      completion: @escaping (_ list: [ToDoItem]) -> Void)
    func addToDoItem(_ item: ToDoItem, completion: @escaping (() -> Void))
    func checkmarkToDoItem(at indexPath: IndexPath,
                           completion: @escaping (_ list: [ToDoItem]) -> Void)
}

final class CoreDataManager {
    
    private(set) var itemsToDoList: [ToDoItem]  {
        get {
            searchItems = []
            return fetchLocalToDoList()
        }
        set {}
    }
    
    private var searchItems: [ToDoItem] = []

    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoListDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext { CoreDataManager.persistentContainer.viewContext }
}

extension CoreDataManager: CoreDataManagerProtocol {
    
    // MARK: - Сохранение задач из бэка в бд
    func saveLocallyToDoList(_ toDoList: [ToDoDTO]) {
        _ = toDoList.map { $0.toEntity(context: context) }
        saveContext()
    }
    
    func editToDoItem(_ item: ToDoItem, completion: @escaping (_ list: [ToDoItem]) -> Void) {
        
        let fetchRequest: NSFetchRequest<ToDoItemEntity> = ToDoItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
       
        do {
            let results = try self.context.fetch(fetchRequest)
            if let toDoItemEntity = results.first {
                toDoItemEntity.title = item.title
                toDoItemEntity.taskDescription = item.taskDescription
                toDoItemEntity.completed = item.completed
                toDoItemEntity.date = item.createdAt.toString()
                
                saveContext()
                
                if let index = self.itemsToDoList.firstIndex(where: { $0.id == item.id }) {
                    self.itemsToDoList[index] = item
                }
                completion(self.itemsToDoList)
            }
        } catch {
            completion(self.itemsToDoList)
        }
    }
    
    func searchToDoItemBy(_ title: String, completion: @escaping (_ list: [ToDoItem]) -> Void) {

        let fetchRequest: NSFetchRequest<ToDoItemEntity> = ToDoItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title BEGINSWITH[cd] %@", title)
       
        do {
            let results = try self.context.fetch(fetchRequest)
            let searchResults = results.compactMap { $0.convertFromEntityToItem() }
            self.searchItems = searchResults
            completion(searchResults)
        } catch {
            completion([])
        }
    }
    
    func removeToDoItem(at indexPath: IndexPath, completion: @escaping () -> Void) {
        
        let item = fetchCurrItem(at: indexPath)
        let fetchRequest: NSFetchRequest<ToDoItemEntity> = ToDoItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
       
        do {
            let results = try self.context.fetch(fetchRequest)
            if let todoEntity = results.first {
                self.context.delete(todoEntity)
                saveContext()
                completion()
            }
        } catch {
            completion()
        }
    }
    
    func checkmarkToDoItem(at indexPath: IndexPath,
                           completion: @escaping (_ list: [ToDoItem]) -> Void) {
        
        let item = fetchCurrItem(at: indexPath)
        let fetchRequest: NSFetchRequest<ToDoItemEntity> = ToDoItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
       
        do {
            let results = try self.context.fetch(fetchRequest)
            if let toDoItemEntity = results.first {
                toDoItemEntity.completed = !item.completed
                let newItem = toDoItemEntity.convertFromEntityToItem()
                saveContext()

                let list = getCurrSortList(item, newItem)
                completion(list)
            }
        } catch {
            completion([])
        }
    }
    
    func addToDoItem(_ item: ToDoItem, completion: @escaping (() -> Void)) {

        let toDoItemEntity = item.toEntity(context: self.context)
        context.insert(toDoItemEntity)
        saveContext()
        itemsToDoList.append(item)
        
        completion()
    }
}

private extension CoreDataManager {
    
    // MARK: - Загрузка всех локальных задач
    func fetchLocalToDoList() -> [ToDoItem] {
       
        let request: NSFetchRequest<ToDoItemEntity> = ToDoItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            let fetchedObjects = try self.context.fetch(request)
            return fetchedObjects.compactMap { $0.convertFromEntityToItem() }
        } catch {
            print("Failed to fetch items")
            return []
        }
    }
    
    // MARK: - Сохранение изменений в Core Data
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                print("Failed to save context")
            }
        }
    }
    
    func fetchCurrItem(at indexPath: IndexPath) -> ToDoItem {
        let item = searchItems.isEmpty ? itemsToDoList[indexPath.row] : searchItems[indexPath.row]
        return item
    }
    
    func getCurrSortList(_ item: ToDoItem,_ newItem: ToDoItem) -> [ToDoItem] {
        if searchItems.isEmpty {
            if let index = itemsToDoList.firstIndex(where: { $0.id == item.id }) {
                itemsToDoList[index] = newItem
            }
            return itemsToDoList
        } else {
            if let index = searchItems.firstIndex(where: { $0.id == item.id }) {
                searchItems[index] = newItem
            }
            return searchItems
        }
    }
}
