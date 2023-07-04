//
//  TodoListCellView.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 02.07.2023.
//

import UIKit

final class TodoListCellView: UITableViewCell {
    
    var model: ViewData.Item?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var contentConfig = defaultContentConfiguration().updated(for: state)
        contentConfig.text = model?.text
        if let deadlineDate = model?.deadline {
            contentConfig.secondaryText = getDeadlineText(date: deadlineDate)
        }
        
        contentConfig.imageProperties.tintColor = .tdSupportSeparator
        contentConfig.image = UIImage(systemName: "circle")
        
        if let model, model.isDone {
            contentConfig.imageProperties.tintColor = .tdGreen
            contentConfig.image = UIImage(systemName: "checkmark.circle.fill")
        } 
        contentConfiguration = contentConfig
    }
    
    private func getDeadlineText(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        dateFormatter.locale = .init(identifier: "ru_RU_POSIX")
        let dateString = dateFormatter.string(from: date)
        
        return " \(dateString)"
    }
    
}
