//
//  ViewData.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 30.06.2023.
//

import Foundation

enum ViewData {
    case initial
    case loading
    case failure(FileCache.FileCacheErrors)
    
    case updateItem(Item)
    case updateItems([Item])
    
    case addItem(Item)
    
    case removeItem(Item)
    case removeItems([Item])
    
    struct Item: Hashable {
        let id: String
        var text: String
        var importance: Importance
        var deadline: Date?
        var isDone: Bool
        var createdAt: Date
        var changedAt: Date?
        
        init(
            id: String = UUID().uuidString,
            text: String,
            importance: Importance = .basic,
            deadline: Date? = nil,
            isDone: Bool = false,
            createdAt: Date = Date(),
            changedAt: Date? = nil
        ) {
            self.id = id
            self.text = text
            self.importance = importance
            self.deadline = deadline
            self.isDone = isDone
            self.createdAt = createdAt
            self.changedAt = changedAt
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}

extension ViewData.Item {
    init(from todoItem: TodoItem) {
        self.init(
            id: todoItem.id,
            text: todoItem.text,
            importance: todoItem.importance,
            deadline: todoItem.deadline,
            isDone: todoItem.isDone,
            createdAt: todoItem.createdAt,
            changedAt: todoItem.changedAt
        )
    }
}
