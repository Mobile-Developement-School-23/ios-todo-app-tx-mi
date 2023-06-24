//
//  DeleteButton.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 24.06.2023.
//

import UIKit

final class DeleteButton: UIButton {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Удалить"
        label.font = .body()
        label.textColor = .tdRed
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
    
    func setup() {
        layer.cornerRadius = 16
        backgroundColor = .tdBackSecondary
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(
            label
        )
        
        makeConstraints()
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}
