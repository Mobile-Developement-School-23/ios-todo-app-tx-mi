//
//  TodoLIstAssembly.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 20.06.2023.
//

import UIKit

final class TodoLIstAssembly {
    
    static func assembly() -> UIViewController {
        let vc = TodoListVC()
        let fileCache = FileCache()
        let presenter = TodoListPresenter(fileCache: fileCache)
        
        presenter.view = vc
        vc.presenter = presenter
        
        let navigationVC = UINavigationController(rootViewController: vc)
        vc.navigationItem.largeTitleDisplayMode = .automatic
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
    
    
}
