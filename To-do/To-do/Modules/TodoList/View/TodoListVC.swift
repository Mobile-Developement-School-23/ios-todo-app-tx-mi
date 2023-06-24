//
//  TodoListVC.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 20.06.2023.
//

import UIKit

protocol TodoListViewInput: AnyObject {
    func setup(todoItems: [TodoItem])
}

final class TodoListVC: UIViewController {
    
    // MARK: Private properties
    private var todoItems: [TodoItem] = []
    
    // MARK: Public properties
    var presenter: TodoListViewOutput?
    
    // MARK: - Initializer
    init(title: String? = "Мои дела") {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tdBackPrimary
        // setup views
        presenter?.viewIsReady()
    }
    
    private func openTodoDetail(at index: Int) {
        let item = index < todoItems.count ? todoItems[index] : .init(text: "", importance: .basic)
        let vc = TodoDetailAssembly.assembly(
            with: item.id,
            fileCache: presenter?.getFileCache() ?? FileCache()
        )
        
        present(vc, animated: true)
    }
    
    
}

// MARK: TodoListViewInput
extension TodoListVC: TodoListViewInput {
    
    func setup(todoItems: [TodoItem]) {
        self.todoItems = todoItems
        openTodoDetail(at: 0) // TODO: Временное решения пока нет списка айтемов. Будет исправлено в ДЗ 3
    }
}
