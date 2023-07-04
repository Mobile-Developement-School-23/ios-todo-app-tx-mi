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
    
    var viewData: ViewData = .initial {
        didSet {
            setNeedsLayout()
        }
    }
    
    private lazy var headerView = TLHeaderView(viewModel: viewModel)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 16
        tableView.register(TodoListCellView.self)
        tableView.delegate = self
        
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
    
    private lazy var dataSource = DataSource(tableView)
    
    private let viewModel: TodoListViewModelProtocol
    
    // MARK: Init
    init(viewModel: TodoListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lyfecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch viewData {
        case .initial:
            break
        case .loading:
            break // TODO: Loading view
            
        case .updateItems(let items):
            dataSource.reloadSnapshot(with: items)
            update(items)
            
        case .updateItem(let item):
            update([item])
            
        case .addItem(let item):
            dataSource.addItems([item])
            update(item)
            
        case .removeItem(let item):
            dataSource.removeItems([item])
            update(item)
            
        case .failure(let error):
            DDLogError("Ошибка при загрузки списка айтемов: \(error)")
        default:
            break
        }
        
    }
    
    private func update(_ item: ViewData.Item) {
        
    }
    
    private func setupViews() {
        addSubviews(
            headerView,
            tableView,
            plusButton
        )
        makeConstraints()
    }
    
    private func makeConstraints() {
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

extension TodoListContentView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            NotificationCenter.default.post(
                name: Constants.openTodoDetail,
                object: item
            )
            DDLogInfo("Открытие Detail view для редактирования айтема с id: \(item.id)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            .makeAction(
                with: .init(systemName: "checkmark.circle.fill"),
                color: .tdGreen,
                completion: { [weak self] in
                    guard let self, let item = dataSource.itemIdentifier(for: indexPath) else { return }
                    self.viewModel.didTapIsDone(with: item.id)
                })
        ])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            .makeAction(
                with: .init(systemName: "trash"),
                color: .tdRed,
                completion: { [weak self] in
                    guard let self, let item = dataSource.itemIdentifier(for: indexPath) else { return }
                    self.viewModel.deleteItem(with: item.id)
                })
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
