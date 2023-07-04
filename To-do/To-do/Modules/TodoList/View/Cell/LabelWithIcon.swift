//
//  TitleWithIcon.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 03.07.2023.
//

import UIKit

final class LabelWithIcon: UIView {
    
    enum Style {
        case important
        case basic
        case low
        case done
        case date
    }
    
    private enum Constants {
        static let defaultLabelAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.title() as Any,
            .foregroundColor: UIColor.tdLabelPrimary as Any,
        ]
        
        static let strokedLabelAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.title() as Any,
            .foregroundColor: UIColor.tdLabelTertiary as Any,
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
        ]
        
        static let dateLabelAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.subhead() as Any,
            .foregroundColor: UIColor.tdLabelTertiary as Any,
        ]
        
    }
    
    var text: String? {
        didSet {
            // Принудительный вызов didSet у style
            let tempValue = style
            style = tempValue
            
            // В случае отсутсвия текста - прячеться вьюшка
            isHidden = text == nil
        }
    }
    
    var style: Style = .basic {
        didSet {
            switch style {
            case .important:
                iconView.image = .importantPriority
                setAttributes(Constants.defaultLabelAttrs)
            case .basic:
                iconView.image = nil
                setAttributes(Constants.defaultLabelAttrs)
            case .low:
                iconView.image = .lowPriorityImg
                setAttributes(Constants.defaultLabelAttrs)
            case .done:
                iconView.image = nil
                setAttributes(Constants.strokedLabelAttrs)
            case .date:
                iconView.image = .dateIconImg
                setAttributes(Constants.dateLabelAttrs)
            }
            iconView.isHidden = iconView.image == nil
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        
        return label
    }()
    
    private lazy var iconView: UIImageView = {
        let image = UIImageView()
        image.isHidden = true
        
        return image
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    init(text: String?, style: Style = .basic) {
        super.init(frame: .zero)
        self.text = text
        self.style = style
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentStackView)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAttributes(_ attributes: [NSAttributedString.Key: Any]? = nil) {
        titleLabel.attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}
