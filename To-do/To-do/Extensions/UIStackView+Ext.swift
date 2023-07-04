//
//  UIStackView+Ext.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 27.06.2023.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
    
}
