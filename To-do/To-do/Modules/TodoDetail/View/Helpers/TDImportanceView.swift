//
//  TDImportanceView.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 24.06.2023.
//

import UIKit

protocol TDImportanceViewProtocol {
    var importance: Importance { get set }
    var importanceChange: ((Importance) -> Void)? { get set }
}

final class TDImportanceView: UIView, TDImportanceViewProtocol {
    
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
    
    var importance: Importance = .basic {
        didSet {
            switch importance {
            case .low:
                segmentedControl.selectedSegmentIndex = 0
            case .basic:
                segmentedControl.selectedSegmentIndex = 1
            case .important:
                segmentedControl.selectedSegmentIndex = 2
            }
        }
    }
    
    var importanceChange: ((Importance) -> Void)?
    
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
        control.selectedSegmentIndex = 1
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
        addActions()
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
    
    private func addActions() {
        // Setup switcher changed action
        segmentedControl.addAction(.init(handler: { [weak self] _ in
            guard let self else { return }
            
            switch self.segmentedControl.selectedSegmentIndex {
            case 0:
                self.importanceChange?(.low)
                self.importance = .low
            case 2:
                self.importanceChange?(.important)
                self.importance = .important
            default:
                self.importanceChange?(.basic)
                self.importance = .basic
            }
        }), for: .valueChanged)
    }
    
}
