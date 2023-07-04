//
//  TodoListVC.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 20.06.2023.
//

import UIKit
import CocoaLumberjackSwift

final class TodoListVC: UIViewController {
    
    // MARK: Private properties
    private enum Constants {
        static let openTodoDetail: Notification.Name = Notification.Name("OpenTodoDetail")
        static let deleteItem: Notification.Name = Notification.Name("deleteItem")
        static let addOrChangeItem: Notification.Name = Notification.Name("addOrChangeItem")
    }
    
    private var viewModel: TodoListViewModel
    private lazy var contenView = TodoListContentView(viewModel: viewModel)
    
    // MARK: Public properties

    // MARK: - Initializer
    init(viewModel: TodoListViewModel, title: String? = "Мои дела") {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = title
        setupNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Constants.openTodoDetail, object: nil)
        NotificationCenter.default.removeObserver(self, name: Constants.deleteItem, object: nil)
        NotificationCenter.default.removeObserver(self, name: Constants.addOrChangeItem, object: nil)
    }
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tdBackPrimary

        // subscribe to update viewData
        viewModel.updateView = { [weak self] viewData in
            self?.contenView.viewData = viewData
        }

        // setup views
        view.addSubview(contenView)
        makeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchItems()
    }
    
    // MARK: - Setup views
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            contenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contenView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contenView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupNotifications() {
                        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(openTodoDetail(_:)),
            name: Constants.openTodoDetail,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteItem(_:)),
            name: Constants.deleteItem,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveItem(_:)),
            name: Constants.addOrChangeItem,
            object: nil
        )
    }

}

extension TodoListVC {
    @objc
    private func openTodoDetail(_ notification: NSNotification) {
        guard let item = notification.object as? ViewData.Item else { return }
        let vc = TodoDetailAssembly.assembly(fileCache: viewModel.getFileCache(), item: item)
        present(vc, animated: true)
    }
    
    @objc
    private func deleteItem(_ notification: NSNotification) {
        guard let itemId = notification.object as? String else { return }
        viewModel.deleteItem(with: itemId)
    }
    
    @objc
    private func saveItem(_ notification: NSNotification) {
        guard let item = notification.object as? ViewData.Item else { return }
        viewModel.addItem(item)
    }
}
