//
//  TodoItem.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 15.06.2023.
//

import Foundation

struct TodoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let createdAt: Date
    let changedAt: Date?
    
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


// MARK: - TodoItem, parsing json and csv
extension TodoItem {
    
    var json: Any {
        var jsonDict: [String: Any] = [
            Keys.id.rawValue: id,
            Keys.text.rawValue: text,
            Keys.isDone.rawValue: isDone,
            Keys.createdAt.rawValue: createdAt.timeIntervalSince1970
        ]
        
        if importance != .basic {
            jsonDict[Keys.importance.rawValue] = importance.rawValue
        }
        
        if let deadline = deadline {
            let timestamp = deadline.timeIntervalSince1970
            jsonDict[Keys.deadline.rawValue] = timestamp
        }
        
        if let changedAt = changedAt {
            let timestamp = changedAt.timeIntervalSince1970
            jsonDict[Keys.changedAt.rawValue] = timestamp
        }
        
        return jsonDict
    }
    
    static func parse(json: Any) -> TodoItem? {
        guard let jsonDict = json as? [String: Any],
              let id = jsonDict[Keys.id.rawValue] as? String,
              let text = jsonDict[Keys.text.rawValue] as? String,
              let createdAt = jsonDict[Keys.createdAt.rawValue] as? TimeInterval
        else {
            return nil
        }
        
        let importance = (jsonDict[Keys.importance.rawValue] as? String)
            .flatMap(Importance.init(rawValue:)) ?? .basic
        
        let isDone = (jsonDict[Keys.isDone.rawValue] as? Bool) ?? false

        let deadline = jsonDict[Keys.deadline.rawValue] as? TimeInterval == nil
            ? nil
            : (jsonDict[Keys.deadline.rawValue] as? TimeInterval).flatMap { Date(timeIntervalSince1970: $0 )}
        
        let changedAt = jsonDict[Keys.changedAt.rawValue] as? TimeInterval == nil
            ? nil
            : (jsonDict[Keys.changedAt.rawValue] as? TimeInterval).flatMap { Date(timeIntervalSince1970: $0) }
        
        return self.init(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            createdAt: Date(timeIntervalSince1970: createdAt),
            changedAt: changedAt
        )
    }
    
    
}

extension TodoItem {
    
    enum Keys: String {
        case id
        case text
        case importance
        case deadline
        case isDone
        case createdAt
        case changedAt
    }
    
}
