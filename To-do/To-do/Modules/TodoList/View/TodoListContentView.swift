//
//  TodoListContentView.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 02.07.2023.
//

import UIKit
import CocoaLumberjackSwift

protocol TodoListContentViewProtocol {
    
}

final class TodoListContentView: UIView, TodoListContentViewProtocol {
    
    private enum Constants {
        static let openTodoDetail: Notification.Name = Notification.Name("OpenTodoDetail")
    }
    
    private let viewModel: TodoListViewModel
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private lazy var headerView = TLHeaderView(viewModel: viewModel)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 16
        tableView.alpha = 0
        tableView.isHidden = true
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.register(TodoListCellView.self)
        
        return tableView
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(.plusButtonImg, for: .normal)
        button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        button.layer.shadowColor = UIColor.tdBlue?.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize.init(width: 0, height: 8)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: Init
    init(viewModel: TodoListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lyfecycle
    
    func update() {
        tableView.reloadData()
        headerView.update()
    }
    
    private func setupViews() {
        addSubviews(
            headerView,
            tableView,
            plusButton,
            spinner
        )
        makeConstraints()
    }
    
    private func makeConstraints() {
        // Spiner
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            headerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            headerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            plusButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            plusButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            plusButton.heightAnchor.constraint(equalToConstant: 44),
            plusButton.widthAnchor.constraint(equalToConstant: 44),
        ])
    }
    
}

extension TodoListContentView {
    
    @objc
    private func didTapPlusButton() {
        NotificationCenter.default.post(
            name: Constants.openTodoDetail,
            object: ViewData.Item(text: "Новое дело")
        )
        DDLogInfo("Открытие Detail view для создания нового айтема")
    }
    
    
}

extension TodoListContentView: TodoListViewModelProtocol {
    
    func didSelectItem(_ item: Item) {
    }
    
    func didLoadItems() {
        spinner.stopAnimating()
        tableView.isHidden = false
        update()
        UIView.animate(withDuration: 0.4) {
            self.tableView.alpha = 1
        }
    }
    
    func updateView() {
        update()
    }
    
}
