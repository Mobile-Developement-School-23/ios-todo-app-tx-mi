//
//  UITableViewCell+Ext.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 02.07.2023.
//

import UIKit

extension UITableViewCell {
    
    static var reuseIdentifier: String {
        String(describing: self)
    }

    var reuseIdentifier: String {
        type(of: self).reuseIdentifier
    }
    
    
}
