//
//  TodoDetailAssembly.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 03.07.2023.
//

import UIKit

final class TodoDetailAssembly {
    
    static func assembly(fileCache: FileCacheProtocol, item: ViewData.Item) -> UIViewController {
        let viewModel = TodoDetailViewModel(fileCache: fileCache, item: item)
        let vc = TodoDetailVC(viewModel: viewModel)
        
        return UINavigationController(rootViewController: vc)
    }
    
}
