//
//  TodoLIstAssembly.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 20.06.2023.
//

import UIKit

final class TodoLIstAssembly {
    
    static func assembly(fileCache: FileCacheProtocol) -> UIViewController {
        let viewModel = TodoListViewModel(fileCache: fileCache)
        let vc = TodoListVC(viewModel: viewModel)
        
        let navigationVC = UINavigationController(rootViewController: vc)
        vc.navigationItem.largeTitleDisplayMode = .automatic
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
    
    
}
