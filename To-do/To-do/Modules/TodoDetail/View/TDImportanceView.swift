//
//  TDImportanceView.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 24.06.2023.
//

import UIKit

final class TDImportanceView: UIView {
    
    private enum Constants {
        static let titleLabelText: String = "Важность"
        static let lowPriority: UIImage? = UIImage.lowPriorityImg?
            .withTintColor(.tdGray ?? .gray, renderingMode: .alwaysOriginal)
        static let importantPriority: UIImage? = UIImage.importantPriorityImg?
            .withTintColor(.tdRed ?? .red, renderingMode: .alwaysOriginal)
        
        static let spacing: CGFloat = 16
        static let verticalInset: CGFloat = 0
        static let leadintInset: CGFloat = 16
        static let trailingInset: CGFloat = 12
        static let segmentedControlWidth: CGFloat = 150
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = Constants.titleLabelText
        label.textColor = .tdLabelPrimary ?? .label
        label.font = .body()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [
            Constants.lowPriority as Any,
            "нет",
            Constants.importantPriority as Any,
        ])
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, segmentedControl])
        stackView.spacing = Constants.spacing
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentStackView)
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.leadintInset
            ),
            contentStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Constants.trailingInset
            ),
            contentStackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Constants.verticalInset
            ),
            contentStackView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -Constants.verticalInset
            ),
            
            segmentedControl.widthAnchor.constraint(equalToConstant: Constants.segmentedControlWidth)
        ])
        
    }
    
}
