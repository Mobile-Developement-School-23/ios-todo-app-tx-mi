//
//  TodoDetailVC.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 20.06.2023.
//

import UIKit

final class TodoDetailVC: UIViewController {
    
    enum ViewState {
        case edit
        case view
    }
    
    private enum Constants {
        static let saveButtonTitle: String = "Сохранить"
        static let cancelButtonTitle: String = "Отменить"
        static let deleteItem: Notification.Name = Notification.Name("deleteItem")
        static let addOrChangeItem: Notification.Name = Notification.Name("addOrChangeItem")
        static let deleteButtonTappedNotification: Notification.Name = Notification.Name("DeleteButtonTapped")
    }
    
    private var viewModel: TodoDetailViewModelProtocol
    private lazy var contenView = TodoDetailContentView(viewModel: viewModel)
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // subscribe to update viewData
        viewModel.updateView = { [weak self] viewData in
            self?.contenView.viewData = viewData
        }
        
        viewModel.fetchItem()
        // setup views
        setupNavigationItems()
        
        contenView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contenView)
        makeConstraints()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        contenView.willTransition(orientation: UIDevice.current.orientation)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        contenView.willDisappear()
    }
    
    // MARK: - Init
    init(viewModel: TodoDetailViewModelProtocol, as: ViewState = .edit, title: String? = "Дело") {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = title
                
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteButtonTapped),
            name: Constants.deleteButtonTappedNotification,
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: Constants.deleteButtonTappedNotification,
            object: nil
        )
    }
    
    // MARK: - Private methods
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            contenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contenView.topAnchor.constraint(equalTo: view.topAnchor),
            contenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
    
    // MARK: - Handlers
    @objc
    private func didTapSave() {
        NotificationCenter.default.post(name: Constants.addOrChangeItem, object: viewModel.item)
        dismiss(animated: true)
    }
    
    @objc
    private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc
    private func deleteButtonTapped() {
        NotificationCenter.default.post(name: Constants.deleteItem, object: viewModel.item.id)
        dismiss(animated: true)
    }

}
