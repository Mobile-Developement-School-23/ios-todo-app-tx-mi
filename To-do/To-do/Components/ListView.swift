//
//  ListView.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 24.06.2023.
//

import UIKit

open class ListView: UIStackView {
    
    private var separatorColor: UIColor? = .tdSupportSeparator ?? .separator
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods
    @discardableResult
    public func addCell(_ cell: UIView, animated: Bool = false) -> Self {
        if !subviews.isEmpty {
            addSeparator()
        }
        
        cell.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(cell)
        
        if !animated {
            addSubview(cell)
        } else {
            UIView.transition(
                with: self,
                duration: 0.25,
                options: [.transitionCrossDissolve],
                animations: {
                    self.addSubview(cell)
                },
                completion: nil)
        }
        
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            cell.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
        
        return self
    }
    
    @discardableResult
    public func removeCell(_ subview: UIView, animated: Bool = false) -> Self {
        guard subviews.contains(subview) else { return self }
        
        removeArrangedSubview(subview)
        if !animated {
            subview.removeFromSuperview()
        } else {
            UIView.transition(
                with: self,
                duration: 0.25,
                options: [.transitionCrossDissolve],
                animations: {
                    subview.removeFromSuperview()
                },
                completion: nil)
        }
        
        if !subviews.isEmpty, let separator = subviews.last {
            removeArrangedSubview(separator)
            separator.removeFromSuperview()
        }
        
        return self
    }
    
    @discardableResult
    public func setBackgroundColor(_ color: UIColor?) -> Self {
        backgroundColor = color ?? .secondarySystemBackground
        return self
    }
    
    @discardableResult
    public func setSeparatorColor(_ color: UIColor?) -> Self {
        separatorColor = color ?? .separator
        
        return self
    }
    
    @discardableResult
    public func setSpacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        
        return self
    }
    
    @discardableResult
    public func setPadding(_ padding: UIEdgeInsets) -> Self {
        layoutMargins = padding
        isLayoutMarginsRelativeArrangement = true
        
        return self
    }
    
    @discardableResult
    public func setCornerRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        
        return self
    }
    
    private func setup() {
        backgroundColor = .secondarySystemBackground
        isLayoutMarginsRelativeArrangement = false
        axis = NSLayoutConstraint.Axis.vertical
        distribution = UIStackView.Distribution.equalSpacing
        alignment = UIStackView.Alignment.center
    }
    
    private func addSeparator() {
        let separator = UIView()
        separator.backgroundColor = separatorColor
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        addArrangedSubview(separator)
        addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    
}
