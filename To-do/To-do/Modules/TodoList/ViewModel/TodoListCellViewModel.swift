//
//  TodoListCellViewModel.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 02.07.2023.
//

import UIKit

final class TodoListCellViewModel {
    
    public var model: Item
    
    public var deadlineText: String? {
        guard let date = model.deadline else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        dateFormatter.locale = .init(identifier: "ru_RU_POSIX")
        let dateString = dateFormatter.string(from: date)
        
        return " \(dateString)"
    }
    
    public var checkMarkImage: UIImage? {
        if model.isDone {
            return .init(systemName: "checkmark.circle.fill")?
                .withTintColor(.tdGreen ?? .green)
        }
        if model.importance == .important {
            return .init(systemName: "circle")?
                .withTintColor(.tdRed ?? .red)
        }
        
        return .init(systemName: "circle")?
            .withTintColor(.tdSupportSeparator ?? .separator)
        
    }
    
    init(model: Item) {
        self.model = model
    }
    
    
}
