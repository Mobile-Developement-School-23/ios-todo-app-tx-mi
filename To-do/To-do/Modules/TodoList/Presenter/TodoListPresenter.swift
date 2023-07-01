//
//  TodoListPresenter.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 20.06.2023.
//

import Foundation

protocol TodoListViewOutput {
    /// Функция загружает данные и в зависимости от ответа настраивает начальный экран
    func viewIsReady()
    
    func getFileCache() -> FileCacheProtocol
    
    func addItem(_ item: TodoItem)
}

final class TodoListPresenter {
    
    // MARK: Public properties
    weak var view: TodoListViewInput?
    
    // MARK: Private properties
    let fileCache: FileCacheProtocol
    
    // MARK: Initialize
    init(fileCache: FileCacheProtocol) {
        self.fileCache = fileCache
    }
    
    private func getItems() -> [TodoItem] {
        fileCache.items.values.map { $0 }
    }
    
    
}

// MARK: - TodoListViewOutput
extension TodoListPresenter: TodoListViewOutput {
    
    func viewIsReady() {
        DispatchQueue.global().async {
            do {
                try self.fileCache.loadItems(from: "items", with: .json)
                
                // Update UI in main queue
                DispatchQueue.main.async {
                    self.view?.setup(todoItems: self.getItems())
                }
                
            } catch {
                print("🤡 Error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func addItem(_ item: TodoItem) {
        fileCache.add(item)
    }
    
    func getFileCache() -> FileCacheProtocol {
        return self.fileCache
    }
    
}
