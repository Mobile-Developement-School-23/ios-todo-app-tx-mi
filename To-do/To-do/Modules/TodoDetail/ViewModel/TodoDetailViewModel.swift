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
    var item: ViewData.Item { get }
    func fetchItem()
    func saveItem()
    func deleteItem()
    func updateText(_ text: String)
    func updateImportance(_ importance: Importance)
    func updateDeadline(_ date: Date?)
}

final class TodoDetailViewModel: TodoDetailViewModelProtocol {
    
    var updateView: ((ViewData) -> Void)?
    
    private let fileCache: FileCacheProtocol
    
    private let itemId: String
    
    private(set) var item: ViewData.Item
    
    init(fileCache: FileCacheProtocol, item: ViewData.Item) {
        self.fileCache = fileCache
        self.item = item
        self.itemId = item.id
        updateView?(.initial)
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
        updateView?(.updateItem(item))
    }
    
    func updateText(_ text: String) {
        DDLogInfo("Изменен текст у копии айтема: \(item.text) -> \(text)")
        item.text = text
        updateView?(.updateItem(item))
    }
    
    func updateImportance(_ importance: Importance) {
        DDLogInfo("Измена важность у копии айтема: \(item.importance.rawValue) -> \(importance.rawValue)")
        item.importance = importance
        updateView?(.updateItem(item))
    }
    
    func updateDeadline(_ date: Date?) {
        DDLogInfo("Изменен дедлайн у копии айтема: \(String(describing: item.deadline)) -> \(String(describing: date))")
        item.deadline = date
        updateView?(.updateItem(item))
    }
    
}
