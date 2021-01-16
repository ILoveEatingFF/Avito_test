//
// Created by Иван Лизогуб on 15.01.2021.
//

import UIKit

class FeedHeader: UICollectionReusableView {
    private let title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Styles.Font.pageTitle
        return label
    }()

    private var didSetupConstraints: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func updateConstraints() {
        if !didSetupConstraints {
            setupConstraints()
            didSetupConstraints = true
        }
        super.updateConstraints()
    }

    private func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func setTitleText(with text: String) {
        title.text = text
    }
}

extension FeedHeader: ReusableView {
    static var identifier: String {
        String(describing: self)
    }
}