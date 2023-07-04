//
//  FileCache.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 15.06.2023.
//

import Foundation
import CocoaLumberjackSwift

protocol FileCacheProtocol {
    var items: [String: TodoItem] { get }
    
    @discardableResult
    func add(_ item: TodoItem) -> TodoItem?
    
    @discardableResult
    func removeItem(with id: String) -> TodoItem?
    
    func saveItems(to fileName: String, with fileExt: FileCache.FileExtension) throws
    func loadItems(from fileName: String, with fileExt: FileCache.FileExtension) throws
}

final class FileCache: FileCacheProtocol {
    
    // MARK: Properties
    private(set) var items: [String: TodoItem] = [:]
    
    // MARK: Public methods - ImpFileCacheProtocol
    @discardableResult
    func add(_ item: TodoItem) -> TodoItem? {
        let oldItem = items[item.id]
        items[item.id] = item
        
        return oldItem
    }
    
    @discardableResult
    func removeItem(with id: String) -> TodoItem? {
        let oldItem = items[id]
        items[id] = nil
        
        return oldItem
    }
    
    func saveItems(to fileName: String, with fileExt: FileExtension = .json) throws {
        let jsonArray = items.values.compactMap { $0.json as? [String: Any] }
        
        do {
            // Преобразуем массив JSON в Data
            let jsonData = try JSONSerialization.data(
                withJSONObject: jsonArray,
                options: .prettyPrinted
            )
            
            // Записываем данные в файл
            let fileManager = FileManager.default
            guard let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                throw FileCacheErrors.cannotFindSystemDirectory
            }
            
            let fileURL = directoryURL
                .appendingPathComponent(fileName)
                .appendingPathExtension(fileExt.rawValue)
            
            try jsonData.write(to: fileURL)
            DDLogInfo("Items saved to file: \(fileURL.absoluteString)")
        } catch {
            DDLogError("Failed to save items to file: \(error)")
        }
    }
    
    func loadItems(from fileName: String, with fileExt: FileExtension = .json) throws {
        let fileManager = FileManager.default
        guard let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheErrors.cannotFindSystemDirectory
        }
        
        let fileURL = directoryURL
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExt.rawValue)
        
        do {
            let data = try Data(contentsOf: fileURL)
            guard let todoItems = try JSONSerialization.jsonObject(with: data) as? [Any]
            else {
                DDLogError("Error when serrialization: \(FileCacheErrors.unparsableData)")
                throw FileCacheErrors.unparsableData
            }
            DDLogInfo("Загружены айтемы с файла \(fileName), по пути: \(fileURL)")
            updateItems(with: todoItems)
        } catch {
            DDLogError(error.localizedDescription)
        }
        
    }
    
    
}

extension FileCache {
    
    enum FileExtension: String {
        case json
    }
    
    enum FileCacheErrors: Error {
        case cannotFindSystemDirectory
        case unparsableData
    }
    
    private func updateItems(with items: [Any]) {
        self.items.removeAll()
        
        items
            .compactMap { TodoItem.parse(json: $0) }
            .forEach { self.items[$0.id] = $0 }
    }
    
    
}
