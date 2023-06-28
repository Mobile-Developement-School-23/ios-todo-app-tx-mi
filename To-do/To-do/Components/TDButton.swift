//
//  TDButton.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 24.06.2023.
//

import UIKit

final class TDButton: UIButton {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Button"
        label.font = .body()
        label.textColor = .tdLabelPrimary
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods
    @discardableResult
    func setText(_ text: String) -> Self {
        label.text = text
        
        return self
    }

    func setBackgroundColor(_ color: UIColor?) -> Self {
        backgroundColor = color
        
        return self
    }
    
    @discardableResult
    func setTextColor(_ color: UIColor?) -> Self {
        label.textColor = color
        
        return self
    }
    
    @discardableResult
    func setFont(_ font: UIFont) -> Self {
        label.font = font
        
        return self
    }
    
    @discardableResult
    func setCornerRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        
        return self
    }
    
    // MARK: Private methods
    private func setup() {
        layer.cornerRadius = 16
        backgroundColor = .tdBackSecondary
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
        ])
    }
}
