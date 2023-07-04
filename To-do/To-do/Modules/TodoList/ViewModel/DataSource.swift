//
//  DataSource.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 02.07.2023.
//

import UIKit

typealias Item = ViewData.Item

enum Section: Hashable {
    case todoList
}

struct SectionData {
    var key: Section
    var values: [Item]
}

protocol DataSourceProtocol {
    func addItems(_ items: [Item])
    func removeItems(_ items: [Item])
    func reloadSnapshot(with items: [Item])
}

final class DataSource: UITableViewDiffableDataSource<Section, Item>, DataSourceProtocol {
    
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.reuse(TodoListCellView.self, indexPath)
            cell.model = item
            cell.isHidden = item.isDone
            
            return cell
        }
    }
    
    func removeItems(_ items: [Item]) {
        var snapshot = snapshot()
        snapshot.deleteItems(items)
        apply(snapshot, animatingDifferences: true)
    }
    
    func addItems(_ items: [Item]) {
        var snapshot = snapshot()
        snapshot.appendItems(items, toSection: Section.todoList)
        apply(snapshot, animatingDifferences: true)
    }
    
    func reloadSnapshot(with items: [Item]) {
        var snapshot = snapshot()
        snapshot.deleteAllItems()
        
        snapshot.appendSections([.todoList])
        snapshot.appendItems(items)
        
        apply(snapshot, animatingDifferences: true)
    }
    
    
}
