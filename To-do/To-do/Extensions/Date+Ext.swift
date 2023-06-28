//
//  Date+Ext.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 27.06.2023.
//

import Foundation

extension Date {
    static func getTomorrow() -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())
        
        return tomorrow ?? Date()
    }
}
