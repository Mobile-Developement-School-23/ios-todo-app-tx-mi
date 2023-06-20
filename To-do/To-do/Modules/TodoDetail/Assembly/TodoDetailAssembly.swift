//
//  TodoDetailAssembly.swift
//  To-do
//
//  Created by Ramazan Abdulaev on 20.06.2023.
//

import UIKit

final class TodoDetailAssembly {
    
    static func assembly(with itemId: String, fileCache: FileCacheProtocol) -> UIViewController {
        let vc = TodoDetailVC()
        let presenter = TodoDetailPresenter(itemId: itemId, fileCache: fileCache)
        
        presenter.view = vc
        vc.presenter = presenter
        
        return UINavigationController(rootViewController: vc)
    }
    
    
}
