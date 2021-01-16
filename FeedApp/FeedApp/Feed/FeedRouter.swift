//
//  FeedRouter.swift
//  FeedApp
//
//  Created by Иван Лизогуб on 13.01.2021.
//  
//

import UIKit

final class FeedRouter: BaseRouter {
}

extension FeedRouter: FeedRouterInput {
    func showAlert(with title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Готово", style: .default))
        viewController?.present(alert, animated: true)
    }


}
