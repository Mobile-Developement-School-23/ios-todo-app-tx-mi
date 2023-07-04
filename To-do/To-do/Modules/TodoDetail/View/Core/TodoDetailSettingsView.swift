//
//  TodoDetailSettingsView.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 27.06.2023.
//

import UIKit

protocol TodoDetailSettingsViewStackProtocol {
    func update(item: ViewData.Item)
}

final class TodoDetailSettingsViewStack: UIStackView, TodoDetailSettingsViewStackProtocol {
    
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
        static let deleteButtonTappedNotification: Notification.Name = Notification.Name("DeleteButtonTapped")
    }
    
    private let viewModel: TodoDetailViewModelProtocol
    
    // MARK: - UI Components
    private lazy var importanceView: TDImportanceView = {
        let view = TDImportanceView(frame: .zero)
        
        view.importanceChange = { [weak self] importance in
            self?.viewModel.updateImportance(importance)
        }
        
        return view
    }()
    
    private lazy var deadlineView: TDDeadlineView = {
        let view = TDDeadlineView(frame: .zero)
        
        view.deadlineSwitched = { [weak self] isOn in
            guard let self else { return }
            if isOn {
                viewModel.updateDeadline(.getTomorrow())
            } else {
                viewModel.updateDeadline(nil)
            }
            
            // Hide datePicker
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
    
    // Костыль для анимации
    private var datePickerSeparator: UIView?
    
    private lazy var deleteButton: TDButton = {
        let button = TDButton()
        button
            .setText(Constants.deleteButtonLabel)
            .setTextColor(.tdRed)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - init
    init(viewModel: TodoDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: ViewData.Item) {
        deadlineView.deadilneDate = item.deadline
        datePicker.date = item.deadline ?? .getTomorrow()
        importanceView.importance = item.importance
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
        let deadlineGesture = UITapGestureRecognizer(target: self, action: #selector(deadlineViewTapped))
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
    
    @objc
    func deleteButtonTapped() {
        NotificationCenter.default.post(
            name: Constants.deleteButtonTappedNotification,
            object: nil
        )
    }
    
    // MARK: DatePicker actions
    @objc
    func deadlineViewTapped() {
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
        viewModel.updateDeadline(newDeadline)
        
        // Скрытие datePicker после выбора даты
        deadlineViewTapped()
    }
    
    
}
