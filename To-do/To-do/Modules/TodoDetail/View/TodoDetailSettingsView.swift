//
//  TodoDetailSettingsView.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 27.06.2023.
//

import UIKit

final class TodoDetailSettingsViewStack: UIStackView {
    
    private enum Constants {
        static let deleteButtonLabel: String = "Удалить"
        static let spacing: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let listViewPaddingInsets: UIEdgeInsets = .init(
            top: 16,
            left: 0,
            bottom: 16,
            right: 0
        )
    }
    
    // MARK: - UI Components
    private let importanceView = TDImportanceView(frame: .zero)
    
    private lazy var deadlineView: TDDeadlineView = {
        let view = TDDeadlineView(frame: .zero)
        
        view.deadlineSwitched = { [weak self] isOn in
            guard let self else { return }
            // TODO: update deadline in model
            if isOn {
                print("Set Date")
            } else {
                print("Delete Date")
            }
            
            if !isOn, !self.datePicker.isHidden {
                UIView.animate(withDuration: 0.3, animations: {
                    self.datePickerSeparator?.isHidden = true
                    self.datePicker.isHidden = true
                })
            }
        }
        
        return view
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.backgroundColor = .tdBackSecondary
        datePicker.locale = .init(identifier: "ru")
        datePicker.isHidden = true
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.addTarget(self, action: #selector(datePickerTapped(sender:)), for: .valueChanged)
        
        return datePicker
    }()
    
    private lazy var listView: ListView = {
        let listView = ListView()
        listView
            .setBackgroundColor(.tdBackSecondary)
            .setPadding(Constants.listViewPaddingInsets)
            .setSpacing(Constants.spacing)
            .setCornerRadius(Constants.cornerRadius)
            .addCell(importanceView)
            .addCell(deadlineView)
            .addCell(datePicker)
        
        let separatorIndex = listView.subviews.count - 2
        datePickerSeparator = listView.subviews[separatorIndex]
        datePickerSeparator?.isHidden = true
        
        listView.translatesAutoresizingMaskIntoConstraints = false
        
        return listView
    }()
    
    private var datePickerSeparator: UIView?
    
    private lazy var deleteButton: TDButton = {
        let button = TDButton()
        button
            .setText(Constants.deleteButtonLabel)
            .setTextColor(.tdRed)
        
        // TODO: Add target for deleteButt
        
        return button
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: - Setup Views
    private func setup() {
        backgroundColor = .clear
        isLayoutMarginsRelativeArrangement = false
        axis = .vertical
        distribution = .equalSpacing
        alignment = .center
        spacing = Constants.spacing
        translatesAutoresizingMaskIntoConstraints = false
        
        addGestures()
        addArrangedSubviews(listView, deleteButton)
        
        makeConstrains()
    }
    
    private func addGestures() {
        // Обработка нажатия на эту вью - позволяет нажимать на даты в datePicker
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
        viewGesture.cancelsTouchesInView = false
        addGestureRecognizer(viewGesture)
        
        // Обработка нажатия на дедлайн - открывает / закрывает datePicker
        let deadlineGesture = UITapGestureRecognizer(target: self, action: #selector(deadlineTapped))
        deadlineView.addGestureRecognizer(deadlineGesture)
    }
    
    private func makeConstrains() {
        NSLayoutConstraint.activate([
            listView.leadingAnchor.constraint(equalTo: leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: trailingAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
}

// MARK: - Handlers
extension TodoDetailSettingsViewStack {
    
    // MARK:  DatePicker actions
    @objc
    func deadlineTapped() {
        guard deadlineView.hasDeadline else { return }
        UIView.animate(withDuration: 0.3, animations: {
            if let isSeparator = self.datePickerSeparator?.isHidden {
                self.datePickerSeparator?.isHidden = !isSeparator
            }
            self.datePicker.isHidden = !self.datePicker.isHidden
        })
        
    }
    
    @objc func datePickerTapped(sender: UIDatePicker) {
        let newDeadline = sender.date
        let dateDouble = Double(newDeadline.timeIntervalSince1970)
        // TODO: Обработка даты
        
        // Скрытие datePicker после выбора даты
        deadlineTapped()
    }
    
    
}
