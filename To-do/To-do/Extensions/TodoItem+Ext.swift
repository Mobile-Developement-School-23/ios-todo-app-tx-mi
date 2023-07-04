//
//  TodoItem+Ext.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 03.07.2023.
//

import Foundation

extension TodoItem {
    
    init(from viewDataItem: ViewData.Item) {
        self.init(
            id: viewDataItem.id,
            text: viewDataItem.text,
            importance: viewDataItem.importance,
            deadline: viewDataItem.deadline,
            isDone: viewDataItem.isDone,
            createdAt: viewDataItem.createdAt,
            changedAt: viewDataItem.changedAt
        )
    }
    
}
