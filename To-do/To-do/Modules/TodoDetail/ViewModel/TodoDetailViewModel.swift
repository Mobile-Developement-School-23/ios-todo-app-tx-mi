//
//  TodoDetailViewModel.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 30.06.2023.
//

import Foundation
import CocoaLumberjackSwift

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
            DDLogInfo("Создана копия айтема для редактирования")
        } else {
            self.item = .init(text: "") // Никогда не сработает
            DDLogError("Ошибка при попытке достать айтем из fileCache, с id: \(itemId)")
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
        DDLogInfo("Добавлен/Обновлен айтем: \(item)")
        try? fileCache.saveItems(to: "items", with: .json)
    }
    
    func deleteItem() {
        fileCache.removeItem(with: itemId)
        DDLogInfo("Удален айтем: \(item)")
        try? fileCache.saveItems(to: "items", with: .json)
    }
    
    func fetchItem() {
        updateView?(.success(item))
    }
    
    func updateText(_ text: String) {
        DDLogInfo("Изменен текст у копии айтема: \(item.text) -> \(text)")
        item.text = text
        updateView?(.success(item))
    }
    
    func updateImportance(_ importance: Importance) {
        DDLogInfo("Измена важность у копии айтема: \(item.importance.rawValue) -> \(importance.rawValue)")
        item.importance = importance
        updateView?(.success(item))
    }
    
    func updateDeadline(_ date: Date?) {
        DDLogInfo("Изменен дедлайн у копии айтема: \(String(describing: item.deadline)) -> \(String(describing: date))")
        item.deadline = date
        updateView?(.success(item))
    }
    
}
