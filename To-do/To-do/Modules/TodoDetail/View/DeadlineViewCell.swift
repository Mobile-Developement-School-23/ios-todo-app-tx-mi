//
//  DeadlineViewCell.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 24.06.2023.
//

import UIKit

final class DeadlineViewCell: UIView {
    var isCalendarShow: ((_ isShow: Bool) -> Void)?
    
    var isCalendarVisible: Bool = false
    
    var selectedDate: Date? = nil {
        didSet {
            subtitleButton.isHidden = selectedDate == nil
            setDate(selectedDate ?? Date())
        }
    }

    private let titlesStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 8
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Cделать до"
        label.textColor = .tdLabelPrimary ?? .label
        label.font = .body()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var subtitleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .footnote()
        button.setTitleColor(.tdBlue, for: .normal)
        
        return button
    }()
    
    private lazy var switchControl: UISwitch = {
        let control = UISwitch()
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
    
    @objc private func didDateTap() {
        isCalendarVisible = !isCalendarVisible
        isCalendarShow?(isCalendarVisible)
    }
    
    private func getTomorrow() -> Date? {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())
        
        return tomorrow
    }
    
    private func setDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateFormatter.locale = .init(identifier: "ru_RU_POSIX")
        let dateString = dateFormatter.string(from: date)
        subtitleButton.setTitle(dateString, for: .normal)
    }
    
    private func setup() {
        switchControl.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            if self.switchControl.isOn {
                self.selectedDate = getTomorrow()
            } else {
                self.selectedDate = nil
                isCalendarShow?(self.switchControl.isOn)
            }
        }, for: .valueChanged)
        
        translatesAutoresizingMaskIntoConstraints = false
        titlesStackView.addArrangedSubview(titleLabel)
        titlesStackView.addArrangedSubview(subtitleButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDateTap))
        titlesStackView.addGestureRecognizer(tapGesture)

        
        addSubviews(titlesStackView, switchControl)
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            switchControl.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            switchControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            titlesStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titlesStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titlesStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titlesStackView.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -16)
        ])
        
        titlesStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
    }
    
}
