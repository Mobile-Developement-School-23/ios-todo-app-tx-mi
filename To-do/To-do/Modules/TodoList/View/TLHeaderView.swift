//
//  TLHeaderView.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 04.07.2023.
//

import UIKit

protocol TLHeaderViewProtocol {
    func update()
}

final class TLHeaderView: UIView, TLHeaderViewProtocol {
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            actionButton
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 16
        
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .tdLabelTertiary
        label.font = .subhead()
        label.text = "Выполнено - \(viewModel.successedCount)"
        
        return label
    }()
    
    private var buttonState: ItemsVisibility = .all {
        didSet {
            updateText()
        }
    }
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.tdBlue, for: .normal)
        button.setTitle(viewModel.visibility.rawValue, for: .normal)
        button.titleLabel?.font = .subhead()
        button.addAction(.init(handler: { [weak self] _ in
            guard let self else { return }
            self.viewModel.visibility = self.buttonState == .all ? .withoutDone: .all
            self.buttonState = self.viewModel.visibility
        }), for: .touchUpInside)
        
        return button
    }()
    
    private var viewModel: TodoListViewModel
    
    init(viewModel: TodoListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        buttonState = viewModel.visibility
        addSubview(contentStackView)
        
        makeConstraints()
    }
        
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        actionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func updateText() {
        actionButton.setTitle(buttonState.rawValue, for: .normal)
    }
    
    func update() {
        titleLabel.text = "Выполнено - \(viewModel.successedCount)"
//        buttonState = viewModel.visibility
    }
    
    
}
