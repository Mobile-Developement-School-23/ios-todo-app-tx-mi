//
//  ImportanceViewCell.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 24.06.2023.
//

import UIKit

final class ImportanceViewCell: UIView {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Важность"
        label.textColor = .tdLabelPrimary ?? .label
        label.font = .body()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let segmentedControl: UISegmentedControl = {
        let lowPriority = UIImage(named: "lowPriority")?
            .withTintColor(.tdGray ?? .gray, renderingMode: .alwaysOriginal)
        let highPriority = UIImage(named: "important")?
            .withTintColor(.tdRed ?? .red, renderingMode: .alwaysOriginal)
 
        let control = UISegmentedControl(items: [
            lowPriority as Any,
            "нет",
            highPriority as Any,
        ])
        control.translatesAutoresizingMaskIntoConstraints = false
        
        return control
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
        addSubviews(nameLabel, segmentedControl)
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            segmentedControl.widthAnchor.constraint(equalToConstant: 150),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
        
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
    }
    
}
