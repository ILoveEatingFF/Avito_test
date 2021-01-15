//
// Created by Иван Лизогуб on 15.01.2021.
//

import UIKit

class BaseRouter {
    var viewControllerProvider: (() -> UIViewController?)?

    var viewController: UIViewController? {
        viewControllerProvider?()
    }
}
