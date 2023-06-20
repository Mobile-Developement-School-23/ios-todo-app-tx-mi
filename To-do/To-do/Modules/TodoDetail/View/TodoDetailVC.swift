//
//  TodoDetailVC.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 20.06.2023.
//

import UIKit

protocol TodoDetailViewInput: AnyObject {
    
}

final class TodoDetailVC: UIViewController  {
    
    var presenter: TodoDetailViewOutput?
    
    // MARK: UI components
    private let scrollView: ScrollViewWithStack = {
        let scrollView = ScrollViewWithStack(arrangedSubviews: [])
        
        return scrollView
    }()
    
    private let textView: ExpandableTextView = {
        let textView = ExpandableTextView()
        textView.placeholder = "Введите текст..."
        textView
            .setFont(UIFont.body())
            .setTextColor(.tdLabelPrimary)
            .setBackgroundColor(.tdBackSecondary)
            .setCornerRadius(16)
            .setTextContainerInsets(.init(
                top: 16,
                left: 16,
                bottom: 16,
                right: 16
            ))
            .useConstraints(true)
        return textView
    }()
    
    private let listView: ListView = {
        let listView = ListView()
            .setPadding(.init(top: 16, left: 0, bottom: 16, right: 0))
            .setSpacing(16)
            .setCornerRadius(16)
            .setBackgroundColor(.tdBackSecondary)
        listView.translatesAutoresizingMaskIntoConstraints = false
        
        return listView
    }()
    
    private let importanceCell: ImportanceViewCell = {
        let cell = ImportanceViewCell()
        
        return cell
    }()
    
    private let calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        calendarView.availableDateRange = DateInterval(
            start: .now,
            end: Date.distantFuture
        )
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = Locale(identifier: "ru")
        calendarView.calendar = calendar
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        return calendarView
    }()
    
    private let deadlineCell: DeadlineViewCell = {
        let cell = DeadlineViewCell()
        
        return cell
    }()
    
    private lazy var deleteButton: DeleteButton = {
        let button = DeleteButton()
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup views
        view.backgroundColor = .tdBackPrimary
        
        calendarView.delegate = self
        importanceCell.segmentedControl.selectedSegmentIndex = presenter?.getImportance() ?? 1
        textView.text = presenter?.text
        
        deadlineCell.isCalendarShow = { [weak self] isShow in
            guard let self, self.deadlineCell.selectedDate != nil else { return }
            if isShow {
                listView.addCell(self.calendarView, animated: true)
            } else {
                listView.removeCell(self.calendarView, animated: true)
            }
        }
        
        listView
            .addCell(importanceCell)
            .addCell(deadlineCell)
        scrollView.addArrangedSubviews([textView, listView, deleteButton])
        addNavButtons()
        addGestures()

        // Add subviews
        view.addSubview(scrollView)
        
        makeConstraints()
       
    }
    
    init(title: String? = "Дело") {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            
            // Text view
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            // Keyboard
            view.keyboardLayoutGuide.topAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: 16
            )
        ])
        
    }
    
    private func addGestures() {
        // Обрабатываем нажатие на любую область экрана, чтоб скрывать клавиатуру
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(viewTapGesture)
    }
    
    private func addNavButtons() {
        let saveButton = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(didTapSave)
        )
        let cancelButton = UIBarButtonItem(
            title: "Отменить",
            style: .plain,
            target: self,
            action: #selector(didTapCancel)
        )
        
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    // MARK: - Handlers
    
    
    @objc
    private func didTapSave() {
        presenter?.saveItem(
            text: textView.text,
            importance: importanceCell.segmentedControl.selectedSegmentIndex,
            deadline: nil
        )
    }
    
    @objc
    private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func deleteButtonTapped() {
        presenter?.deleteButtonTapped()
        dismiss(animated: true)
    }
    
}

// MARK: - TodoDetailViewInput
extension TodoDetailVC: TodoDetailViewInput, UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        .default()
    }
    
    func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
        print(calendarView.calendar.timeZone)
    }
    
}
