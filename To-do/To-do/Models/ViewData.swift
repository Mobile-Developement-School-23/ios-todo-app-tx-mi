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
    case success(Item)
    case failure(FileCache.FileCacheErrors)
    
    struct Item {
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
    }
}
