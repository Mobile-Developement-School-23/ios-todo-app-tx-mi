//
//  UITableView+Ext.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 02.07.2023.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ type: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func reuse<T: UITableViewCell>(_ type: T.Type, _ indexPath: IndexPath) -> T {
        // swiftlint:disable:next force_cast
        dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func select(_ indexPaths: [IndexPath],
                animated: Bool = true,
                scrollPosition: UITableView.ScrollPosition = .none) {
        for indexPath in indexPaths {
            selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        }
    }
    
    
    func deselect(_ indexPaths: [IndexPath], animated: Bool = true) {
        for indexPath in indexPaths {
            deselectRow(at: indexPath, animated: animated)
        }
    }
    
    func deselectAll(animated: Bool = true) {
        deselect(indexPathsForSelectedRows ?? [], animated: animated)
    }
    
    func deselectAllInSection(except indexPath: IndexPath) {
        let indexPathsToDeselect = (indexPathsForSelectedRows ?? []).filter {
            $0.section == indexPath.section && $0.row != indexPath.row
        }
        deselect(indexPathsToDeselect)
    }
    
}
