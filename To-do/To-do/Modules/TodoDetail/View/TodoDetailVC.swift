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
    
    private enum Constants {
        static let saveButtonTitle: String = "Сохранить"
        static let cancelButtonTitle: String = "Отменить"
        static let placeholderText: String = "Введите текст..."
        static let minTextViewHeight: CGFloat = 120
        static let spacing: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let verticalInset: CGFloat = 16
        static let horizontalInset: CGFloat = 16
        static let srollViewInsets: UIEdgeInsets = .init(
            top: 16,
            left: 0,
            bottom: 16,
            right: 0
        )
        static let textContainterInsets: UIEdgeInsets = .init(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )
    }
    
    var presenter: TodoDetailViewOutput?
    
    private lazy var keyboardConstraint = scrollView.bottomAnchor.constraint(
        equalTo: view.keyboardLayoutGuide.topAnchor
    )
    
    // MARK: - UI components
    private let scrollView: TDScrollViewWithStack = {
        let scrollView = TDScrollViewWithStack(arrangedSubviews: [])
        scrollView.keyboardDismissMode = .interactive
        scrollView.contentInset = Constants.srollViewInsets
        
        return scrollView
    }()
    
    private let textView: ExpandableTextView = {
        let textView = ExpandableTextView()
        textView.placeholder = Constants.placeholderText
        textView
            .setFont(UIFont.body())
            .setTextColor(.tdLabelPrimary)
            .setBackgroundColor(.tdBackSecondary)
            .setCornerRadius(Constants.cornerRadius)
            .setTextContainerInsets(Constants.textContainterInsets)
            .useConstraints(true)
        return textView
    }()
    
    private let settingsViewStack =  TodoDetailSettingsViewStack(frame: .zero)
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup views
        view.backgroundColor = .tdBackPrimary
        setupNavigationItems()
        addGestures()
        
        // Add subviews
        scrollView.addArrangedSubviews(textView, settingsViewStack)
        view.addSubview(scrollView)
        
        makeConstraints()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape, FeatureFlags.splittedDeatilViewInLandscape {
            scrollView.setAxis(.horizontal)
        } else {
            scrollView.setAxis(.vertical)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Удаляем констрейнт с keyboardLayoutGuide при скрытии вьюшки, чтоб не было ошибок
        NSLayoutConstraint.deactivate([keyboardConstraint])
        view.removeConstraint(keyboardConstraint)
    }
    
    // MARK: - Init
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
                constant: Constants.horizontalInset
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.horizontalInset
            ),
            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.verticalInset
            ),
            keyboardConstraint,
            
            // Text view
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.minTextViewHeight),
            
        ])
        
    }
    
    private func setupNavigationItems() {
        let saveButton = UIBarButtonItem(
            title: Constants.saveButtonTitle,
            style: .done,
            target: self,
            action: #selector(didTapSave)
        )
        let cancelButton = UIBarButtonItem(
            title: Constants.cancelButtonTitle,
            style: .plain,
            target: self,
            action: #selector(didTapCancel)
        )
        
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func addGestures() {
        /// Обрабатываем нажатие на любую область экрана, чтоб скрывать клавиатуру
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(viewTapGesture)
    }
    
    // MARK: - Handlers
    @objc
    private func didTapSave() {
        // TODO: Сохранять в модель данные пользователя
    }
    
    @objc
    private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - TodoDetailViewInput
extension TodoDetailVC: TodoDetailViewInput {
    
    
}
