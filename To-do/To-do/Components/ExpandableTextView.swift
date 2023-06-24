//
//  ExpandableTextView.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 23.06.2023.
//

import UIKit

open class ExpandableTextView: UITextView {
    
    // MARK: Properties
    private let placeholderLabel: UILabel = UILabel()
    
    private var placeholderConstraints: [NSLayoutConstraint] = []
    
    public var placeholderColor: UIColor = .tdLabelSecondary ?? .secondaryLabel {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    public var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    open override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
    // MARK: Init
    public init() {
        super.init(frame: .zero, textContainer: nil)
        delegate = self
        isScrollEnabled = false
        setupPlaceholderLabel()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods
    @discardableResult
    public func setCornerRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        
        return self
    }
    
    @discardableResult
    public func setFont(_ font: UIFont?) -> Self {
        self.font = font
        placeholderLabel.font = font
        
        return self
    }
    
    @discardableResult
    public func useConstraints(_ isConstraints: Bool) -> Self {
        translatesAutoresizingMaskIntoConstraints = !isConstraints
        
        return self
    }

    @discardableResult
    public func setTextContainerInsets(_ insets: UIEdgeInsets) -> Self {
        removePlaceholderConstraints()
        textContainerInset = insets
        makePlaceholderConstraints()
        layoutIfNeeded()

        return self
    }
    
    @discardableResult
    public func setTextColor(_ color: UIColor?) -> Self {
        self.textColor = color
        
        return self
    }
    
    @discardableResult
    public func setBackgroundColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        
        return self
    }
    
    
    // MARK: Public methods
    private func setupPlaceholderLabel() {
        placeholderLabel.font = font
        placeholderLabel.textColor = .secondaryLabel
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        
        makePlaceholderConstraints()
    }
    
    private func makePlaceholderConstraints() {
        setPlaceholderConstraints()
        NSLayoutConstraint.activate(placeholderConstraints)
    }
    
    private func removePlaceholderConstraints() {
        NSLayoutConstraint.deactivate(placeholderConstraints)
        removeConstraints(placeholderConstraints)
    }
    
    private func setPlaceholderConstraints() {
        placeholderConstraints = [
            placeholderLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: textContainerInset.left
            ),
            placeholderLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -textContainerInset.right
            ),
            placeholderLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: textContainerInset.top
            ),
            placeholderLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -textContainerInset.bottom
            )
        ]
    }
    
    
}

// MARK: UITextViewDelegate
extension ExpandableTextView: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !text.isEmpty
    }

    
}
