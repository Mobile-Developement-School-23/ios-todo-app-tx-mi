//
//  TodoDetailViewModel.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 30.06.2023.
//

import Foundation

protocol TodoDetailViewModelProtocol {
    var updateView: ((ViewData) -> Void)? { get set }
    func fetchItem()
    func saveItem()
    func deleteItem()
    func updateText(_ text: String)
    func updateImportance(_ importance: Importance)
    func updateDeadline(_ date: Date?)
}

final class TodoDetailViewModel: TodoDetailViewModelProtocol {
    
    public var updateView: ((ViewData) -> Void)?
    
    private let fileCache: FileCacheProtocol
    
    private let itemId: String
    
    private var item: ViewData.Item
    
    init(fileCache: FileCacheProtocol, itemId: String) {
        self.fileCache = fileCache
        self.itemId = itemId
        updateView?(.initial)
        
        if let fileCacheItem = fileCache.items[itemId] {
            self.item = .init(
                id: itemId,
                text: fileCacheItem.text,
                importance: fileCacheItem.importance,
                deadline: fileCacheItem.deadline,
                isDone: fileCacheItem.isDone,
                createdAt: fileCacheItem.createdAt,
                changedAt: fileCacheItem.changedAt
            )
        } else {
            self.item = .init(text: "") // Никогда не сработает
        }
        
    }
    
    func saveItem() {
        fileCache.add(.init(
            id: itemId,
            text: item.text,
            importance: item.importance,
            deadline: item.deadline,
            isDone: item.isDone,
            createdAt: item.createdAt,
            changedAt: Date()
        ))
        try? fileCache.saveItems(to: "items", with: .json)
    }
    
    func deleteItem() {
        fileCache.removeItem(with: itemId)
        try? fileCache.saveItems(to: "items", with: .json)
    }
    
    func fetchItem() {
        updateView?(.success(item))
    }
    
    func updateText(_ text: String) {
        item.text = text
        updateView?(.success(item))
    }
    
    func updateImportance(_ importance: Importance) {
        item.importance = importance
        updateView?(.success(item))
    }
    
    func updateDeadline(_ date: Date?) {
        item.deadline = date
        updateView?(.success(item))
    }
    
}
