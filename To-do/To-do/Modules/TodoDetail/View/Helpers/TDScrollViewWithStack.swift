//
//  TDScrollViewWithStack.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 24.06.2023.
//

import UIKit

final class TDScrollViewWithStack: UIScrollView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(arrangedSubviews: [UIView] = []) {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            stackView.addArrangedSubview(view)
        }
    }
    
    func setAxis(_ axis: NSLayoutConstraint.Axis) {
        self.stackView.axis = axis
    }
    
    private func setup() {
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(stackView)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
        
    }
    
    
}
