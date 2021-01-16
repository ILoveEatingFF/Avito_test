//
// Created by Иван Лизогуб on 16.01.2021.
//

import UIKit

extension UIImageView {
    func setImage(with url: URL?) {
        guard let url = url else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
