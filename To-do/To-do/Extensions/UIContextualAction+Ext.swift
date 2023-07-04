//
//  UIContextualAction+Ext.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 04.07.2023.
//

import UIKit

extension UIContextualAction {
    static func makeAction(
        with image: UIImage?,
        color: UIColor?,
        completion: (() -> Void)? = nil
    ) -> UIContextualAction {
        guard let image, let color else {
            return UIContextualAction(style: .normal, title: "Sample", handler: {_, _, _ in})
        }
        let action = UIContextualAction(
            style: .normal,
            title: nil,
            handler: { _, _, _ in completion?() }
        )
        action.image = image
        action.backgroundColor = color
        return action
    }
}
