//
//  TodoDetailContentView.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 30.06.2023.
//

import UIKit

final class TodoDetailContentView: UIView {
    
    private enum Constants {
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
    
    private let viewModel: TodoDetailViewModelProtocol
    
    public var viewData: ViewData = .initial {
        didSet {
            setNeedsLayout()
        }
    }
    
    private lazy var keyboardConstraint = scrollView.bottomAnchor.constraint(
        equalTo: keyboardLayoutGuide.topAnchor
    )
    
    // MARK: - UI components
    private let scrollView: TDScrollViewWithStack = {
        let scrollView = TDScrollViewWithStack(arrangedSubviews: [])
        scrollView.keyboardDismissMode = .interactive
        scrollView.contentInset = Constants.srollViewInsets
        
        return scrollView
    }()
    
    private lazy var textView: ExpandableTextView = {
        let textView = ExpandableTextView()
        textView.delegate = self
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
    
    private lazy var settingsViewStack =  TodoDetailSettingsViewStack(viewModel: viewModel)
    
    // MARK: - Init
    init(viewModel: TodoDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        // setup views
        backgroundColor = .tdBackPrimary
        addGestures()
        
        // Add subviews
        scrollView.addArrangedSubviews(textView, settingsViewStack)
        addSubview(scrollView)
        
        makeConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch viewData {
        case .initial:
            update(item: .init(text: ""), isHidden: true)
        case .loading:
            update(item: .init(text: "Идет загрузка..."), isHidden: true)
        case .success(let todoItem):
            update(item: todoItem)
        case .failure(let fileCacheErrors):
            update(item: .init(text: "Не удалось загрузить айтем, по причине: \(fileCacheErrors.localizedDescription)"))
        }
    }

    func willTransition(orientation: UIDeviceOrientation) {
        if orientation.isLandscape, FeatureFlags.splittedDeatilViewInLandscape {
            scrollView.setAxis(.horizontal)
        } else {
            scrollView.setAxis(.vertical)
        }
    }
    
    func willDisappear() {
        // Удаляем констрейнт с keyboardLayoutGuide при скрытии вьюшки, чтоб не было ошибок
        NSLayoutConstraint.deactivate([keyboardConstraint])
        removeConstraint(keyboardConstraint)
    }
    
    // MARK: - Private methods
        
    private func update(item: ViewData.Item, isHidden: Bool = false) {
        textView.text = item.text
        settingsViewStack.update(item: item)
        
        textView.isHidden = isHidden
        settingsViewStack.isHidden = isHidden
    }
    
    private func makeConstraints() {
        
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.horizontalInset
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.horizontalInset
            ),
            scrollView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: Constants.verticalInset
            ),
            keyboardConstraint,
            
            // Text view
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.minTextViewHeight),
            
        ])
        
    }
    
    private func addGestures() {
        /// Обрабатываем нажатие на любую область экрана, чтоб скрывать клавиатуру
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(viewTapGesture)
    }
    
    // MARK: - Handlers
    @objc
    private func dismissKeyboard() {
        endEditing(true)
    }

}

extension TodoDetailContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.updateText(textView.text)
    }
}
