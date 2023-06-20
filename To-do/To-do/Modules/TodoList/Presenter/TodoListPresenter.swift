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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            do {
                try self.fileCache.loadItems(from: "items", with: .json)
                self.view?.setup(todoItems: self.getItems())
            } catch {
                print("🤡 Error: \(error.localizedDescription)")
                // TODO: Добавить setup с mode для отображения ошибки
            }
        }
    }
    
    func getFileCache() -> FileCacheProtocol {
        return self.fileCache
    }
    
}
