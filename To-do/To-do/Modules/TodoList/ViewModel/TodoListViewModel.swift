//
//  TodoLIstViewModel.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 02.07.2023.
//

import UIKit
import CocoaLumberjackSwift

protocol TodoListViewModelProtocol: AnyObject {
    func didSelectItem(_ item: Item)
    func didLoadItems()
    func updateView()
}

enum ItemsVisibility: String {
    case all = "Скрыть"
    case withoutDone = "Показать"
}

final class TodoListViewModel: NSObject {
    
    public weak var delegate: TodoListViewModelProtocol?
    
    var visibility: ItemsVisibility = .all {
        didSet {
            delegate?.updateView() 
        }
    }
    
    var visibleCount: Int {
        fileCache.items
            .filter { !$0.isDone && visibility == .withoutDone || visibility == .all }
            .count
    }
    
    var successedCount: Int {
        fileCache.items
            .filter { !$0.isDone }
            .count
    }
    
    private let fileCache: FileCacheProtocol
    
    init(fileCache: FileCacheProtocol) {
        self.fileCache = fileCache
    }
    
    func fetchItems() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            do {
                try self.fileCache.loadItems(from: "items", with: .json)
                
                // TODO: Update UI in main queue
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didLoadItems()
                }
                
            } catch {
                DDLogError("🤡 Error: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteItem(with id: String) {
        fileCache.removeItem(with: id)
    }
    
    func getFileCache() -> FileCacheProtocol {
        return self.fileCache
    }
    
}

extension TodoListViewModel: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        visibleCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }


}
