//
//  TodoDetailPresenter.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 20.06.2023.
//

import Foundation

protocol TodoDetailViewOutput {
    
    func saveItem(text: String, importance: Int, deadline: Date?)
    
    func getImportance() -> Int
    
    var text: String? { get }
    
    func deleteButtonTapped()
}

final class TodoDetailPresenter {
    
    weak var view: TodoDetailViewInput?
    
    var text: String? {
        return fileCache.items[itemId]?.text
    }
    
    private let itemId: String
    
    private let fileCache: FileCacheProtocol
    
    init(itemId: String, fileCache: FileCacheProtocol) {
        self.itemId = itemId
        self.fileCache = fileCache
    }
    
    private func getImportance(by num: Int) -> Importance {
        switch num {
        case 0:
            return .low
        case 1:
            return .basic
        default:
            return .important
        }
    }
}

// MARK: TodoDetailViewOutput
extension TodoDetailPresenter: TodoDetailViewOutput {
    
    func saveItem(text: String, importance: Int, deadline deadilne: Date?) {
        fileCache.add(.init(text: text,
                            importance: getImportance(by: importance),
                            deadline: deadilne,
                            changedAt: Date()
                           ))
        try? fileCache.saveItems(to: "items", with: .json)
    }
    
    func deleteItem() {
        fileCache.removeItem(with: itemId)
    }
    
    func getImportance() -> Int {
        guard let item = fileCache.items[itemId] else { return 1 }
        switch item.importance {
        case .basic:
            return 1
        case .low:
            return 0
        default:
            return 2
        }
        
    }
    
    func deleteButtonTapped() {
        fileCache.removeItem(with: itemId)
        try? fileCache.saveItems(to: "items", with: .json)
    }
}
