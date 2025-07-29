//
//  ToDoItemEntity+CoreDataProperties.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 21.07.2025.
//
//

import Foundation
import CoreData

extension ToDoItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItemEntity> {
        return NSFetchRequest<ToDoItemEntity>(entityName: "ToDoItemEntity")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var date: String
    @NSManaged public var id: UUID
    @NSManaged public var taskDescription: String?
    @NSManaged public var title: String

}

extension ToDoItemEntity: Identifiable {
    func convertFromEntityToItem() -> ToDoItem {
        ToDoItem(id: id,
                 title: title,
                 completed: completed,
                 taskDescription: taskDescription,
                 createdAt: date.toDate())
    }
}

extension ToDoItem {
    func toEntity(context: NSManagedObjectContext) -> ToDoItemEntity {
        let entity = ToDoItemEntity(context: context)
        entity.id = id
        entity.date = createdAt.toString()
        entity.taskDescription = taskDescription
        entity.title = title
        entity.completed = completed
        return entity
    }
}

extension ToDoDTO {
    func toEntity(context: NSManagedObjectContext) -> ToDoItemEntity {
        let entity = ToDoItemEntity(context: context)
        entity.id = UUID()
        entity.date = Date().toString()
        entity.taskDescription = todo
        entity.title = todo.createShortTitle()
        entity.completed = completed
        return entity
    }
}
