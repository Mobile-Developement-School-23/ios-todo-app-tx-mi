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
    public func addCell(_ cell: UIView, animated: Bool = false, withSeparator isSeparator: Bool = true) -> Self {
        if !subviews.isEmpty, isSeparator {
            addSeparator()
        }
        
        cell.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(cell)
        if animated {
            UIView.animate(withDuration: 0.35, animations: {
                cell.layoutIfNeeded()
            })
        }
        NSLayoutConstraint.activate([
            cell.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            cell.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
        
        return self
    }
    
    @discardableResult
    public func removeCell(_ cell: UIView, animated: Bool = false) -> Self {
        guard subviews.contains(cell) else { return self }
        
        if animated {
            UIView.transition(
                with: self,
                duration: 0.35,
                options: [.transitionCrossDissolve],
                animations: {
                    self.removeArrangedSubview(cell)
                },
                completion: nil
            )
        } else {
            removeArrangedSubview(cell)
        }
        removeSeparator()
        
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
    
    @discardableResult
    public func addSeparator() -> Self {
        let separator = UIView()
        separator.backgroundColor = separatorColor
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        addArrangedSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -16),
        ])
        
        return self
    }
    
    @discardableResult
    public func removeSeparator() -> Self {
        if !subviews.isEmpty, let separator = subviews.last {
            removeArrangedSubview(separator)
        }
        
        return self
    }
    
    private func setup() {
        backgroundColor = .secondarySystemBackground
        isLayoutMarginsRelativeArrangement = false
        axis = .vertical
        distribution = .equalSpacing
        alignment = .center
    }
    
    
    
}
