//
//  TDDeadlineView.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 24.06.2023.
//

import UIKit

protocol TDDeadlineViewProtocol {
    var hasDeadline: Bool { get }
    var deadlineSwitched: ((_ isOn: Bool) -> Void)? { get set }
}

final class TDDeadlineView: UIView, TDDeadlineViewProtocol {
    
    private enum Constants {
        static let titleLabelText: String = "Сделать до"
        static let spacing: CGFloat = 16
        static let verticalInset: CGFloat = 0
        static let leadintInset: CGFloat = 16
        static let trailingInset: CGFloat = 12
    }
    
    // Protocol
    var hasDeadline: Bool {
        switchControl.isOn
    }
    
    var deadlineSwitched: ((_ isOn: Bool) -> Void)?
    
    // MARK: - Private Props
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = Constants.titleLabelText
        label.textColor = .tdLabelPrimary ?? .label
        label.font = .body()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .tdBlue ?? .secondaryLabel
        label.font = .footnote()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var switchControl: UISwitch = {
        let control = UISwitch()
        control.translatesAutoresizingMaskIntoConstraints = false
        
        control.addAction(.init(handler: { [weak self] _ in
            self?.deadlineSwitched?(control.isOn)
        }), for: .valueChanged)
        
        return control
    }()
    
    private let titlesStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 8
        return stack
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titlesStackView, switchControl])
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
    
    private func setDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = .init(identifier: "ru_RU_POSIX")
        let dateString = dateFormatter.string(from: date)
        
        subtitleLabel.text = dateString
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        titlesStackView.addArrangedSubviews(titleLabel, subtitleLabel)
        
        addSubviews(contentStackView)
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
            
        ])
        
        titlesStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
}
