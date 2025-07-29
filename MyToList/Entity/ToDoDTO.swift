//
//  ToDoEntity.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 21.07.2025.
//

import Foundation

struct ToDosResponse: Codable {
    let todos: [ToDoDTO]
}

struct ToDoDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
