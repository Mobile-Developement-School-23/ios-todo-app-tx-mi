//
//  UIFont+Ext.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 24.06.2023.
//

import UIKit

extension UIFont {

    static func largeTitle() -> UIFont? {
        UIFont.init(name: "SFProDisplay-Bold", size: 38)
    }

    static func title() -> UIFont? {
        UIFont.init(name: "SFProDisplay-Medium", size: 20)
    }

    static func headline() -> UIFont? {
        UIFont.init(name: "SFProText-Medium", size: 17)
    }

    static func body() -> UIFont? {
        UIFont.init(name: "SFProText-Light", size: 17)
    }

    static func subhead() -> UIFont? {
        UIFont.init(name: "SFProText-Light", size: 15)
    }

    static func footnote() -> UIFont? {
        UIFont.init(name: "SFProText-Semibold", size: 13)
    }

}
