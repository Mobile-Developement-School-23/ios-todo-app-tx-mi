//
//  FileCache.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 15.06.2023.
//

import Foundation
import CocoaLumberjackSwift

enum FileExtension: String {
    case json
}

enum FileCacheErrors: Error {
    case cannotFindSystemDirectory
    case unparsableData
}

protocol FileCacheProtocol {
    var items: [Item] { get }
    
    @discardableResult
    func add(_ item: Item) -> Item?
    
    @discardableResult
    func removeItem(with id: String) -> Item?
    
    func saveItems(to fileName: String, with fileExt: FileExtension) throws
    func loadItems(from fileName: String, with fileExt: FileExtension) throws
}

final class FileCache: FileCacheProtocol {
    
    // MARK: Properties
    private(set) var items: [Item] = []
    
    // MARK: Public methods - ImpFileCacheProtocol
    @discardableResult
    func add(_ item: Item) -> Item? {
        if let indexOldItem = items.firstIndex(where: { $0.id == item.id }) {
            items[indexOldItem] = item
            return items[indexOldItem]
        } else {
            items.append(item)
            return item
        }
    }
    
    @discardableResult
    func removeItem(with id: String) -> Item? {
        if let index = items.firstIndex(where: { $0.id == id }) {
            return items.remove(at: index)
        }
        
        return nil
    }
    
    func saveItems(to fileName: String, with fileExt: FileExtension = .json) throws {
        let jsonArray = items.compactMap { $0.json }
        
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
            guard let todoItemsJson = try JSONSerialization.jsonObject(with: data) as? [Any]
            else {
                DDLogError("Error when serrialization: \(FileCacheErrors.unparsableData)")
                throw FileCacheErrors.unparsableData
            }
            DDLogInfo("Загружены айтемы с файла \(fileName), по пути: \(fileURL)")
            items = todoItemsJson.compactMap { Item.parse(json: $0) }
        } catch {
            DDLogError(error.localizedDescription)
        }
        
    }
    
    
}
