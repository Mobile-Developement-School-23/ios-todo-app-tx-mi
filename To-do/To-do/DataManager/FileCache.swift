//
//  FileCache.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 15.06.2023.
//

import Foundation

protocol FileCacheProtocol {
    var items: [String: TodoItem] { get }
    func add(_ item: TodoItem) -> TodoItem?
    func removeItem(with id: String) -> TodoItem?
    func saveItems(to fileName: String, with fileExt: FileCache.FileExtension)
    func loadItems(from fileName: String, with fileExt: FileCache.FileExtension)
}

final class FileCache: FileCacheProtocol {
    
    // MARK: Properties
    private(set) var items: [String: TodoItem] = [:]
    
    // MARK: Public methods - ImpFileCacheProtocol
    func add(_ item: TodoItem) -> TodoItem? {
        let oldItem = items[item.id]
        items[item.id] = item
        
        return oldItem
    }
    
    func removeItem(with id: String) -> TodoItem? {
        let oldItem = items[id]
        items[id] = nil
        
        return oldItem
    }
    
    func saveItems(to fileName: String, with fileExt: FileExtension = .json) {
        let jsonArray = items.values.compactMap { $0.json as? [String: Any] }
        
        do {
            // Преобразуем массив JSON в Data
            let jsonData = try JSONSerialization.data(
                withJSONObject: jsonArray,
                options: .prettyPrinted
            )
            
            // Записываем данные в файл
            let fileURL = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)[0]
                .appendingPathComponent(fileName)
                .appendingPathExtension(fileExt.rawValue)
            
            try jsonData.write(to: fileURL)
            print("Items saved to file: \(fileName)")
        } catch {
            print("Failed to save items to file: \(error)")
        }
    }
    
    func loadItems(from fileName: String, with fileExt: FileExtension = .json) {
        let fileURL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExt.rawValue)
        
        do {
            let data = try Data(contentsOf: fileURL)
            guard let todoItems = try JSONSerialization.jsonObject(with: data) as? [Any]
            else { return }
            updateItems(with: todoItems)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
}

extension FileCache {
    
    enum FileExtension: String {
        case json
    }
    
    private func updateItems(with items: [Any]) {
        self.items.removeAll()
        
        items
            .compactMap { TodoItem.parse(json: $0) }
            .forEach { self.items[$0.id] = $0 }
    }
    
    
}
