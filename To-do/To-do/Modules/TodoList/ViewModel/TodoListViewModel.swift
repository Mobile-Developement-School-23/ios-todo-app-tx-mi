//
//  TodoLIstViewModel.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 02.07.2023.
//

import UIKit
import CocoaLumberjackSwift

protocol TodoListViewModelProtocol: AnyObject {
    var updateView: ((ViewData) -> Void)? { get set }
    var todoItems: [ViewData.Item] { get }
    var visibility: ItemsVisibility { get set }
    
    func fetchItems()
    func getFileCache() -> FileCacheProtocol
    
    func didTapIsDone(with id: String)
    func deleteItem(with id: String)
    @discardableResult
    func addItem(_ item: ViewData.Item) -> ViewData.Item?
}

enum ItemsVisibility: String {
    case all = "Скрыть"
    case withoutDone = "Показать"
}

final class TodoListViewModel: TodoListViewModelProtocol {
    
    var updateView: ((ViewData) -> Void)?
    
    var visibility: ItemsVisibility = .all {
        didSet {
            updatedItems()
        }
    }
    
    private(set) var todoItems: [ViewData.Item] = []
    
    private let fileCache: FileCacheProtocol
    
    init(fileCache: FileCacheProtocol) {
        self.fileCache = fileCache
        updateView?(.initial)
    }
    
    func fetchItems() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            do {
                try self.fileCache.loadItems(from: "items", with: .json)
                
                // Update UI in main queue
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.todoItems = self.fileCache.items.values
                        .map { .init(from: $0) }
                        .sorted { $0.changedAt ?? $0.createdAt > $1.changedAt ?? $1.createdAt }
                    self.updatedItems()
                }
                
            } catch {
                DDLogError("🤡 Error: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteItem(with id: String) {
        if let index = todoItems.firstIndex(where: { $0.id == id }) {
            updateView?(.removeItem(todoItems[index]))
            todoItems.remove(at: index)
        }
    }
    
    /// Вернет старый item который мы заменяй, если такого нет - то nil
    @discardableResult
    func addItem(_ item: ViewData.Item) -> ViewData.Item? {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            let oldItem = todoItems[index]
            todoItems[index] = item
            updateView?(.updateItem(todoItems[index]))
            
            return oldItem
        }
        todoItems.append(item)
        updateView?(.addItem(item))
        
        return nil
    }
    
    func didTapIsDone(with id: String) {
        if let index = todoItems.firstIndex(where: { $0.id == id }) {
            todoItems[index].isDone = !todoItems[index].isDone
            updateView?(.updateItem(todoItems[index]))
        }
    }
    
    func getFileCache() -> FileCacheProtocol {
        return self.fileCache
    }
    
    private func updatedItems() {
        updateView?(.updateItems(
            todoItems.filter { !$0.isDone && visibility == .withoutDone || visibility == .all }
        ))
    }
    
}
