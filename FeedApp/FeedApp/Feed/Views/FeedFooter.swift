//
// Created by Иван Лизогуб on 15.01.2021.
//

import UIKit

class FeedFooter: UICollectionReusableView {
    var chooseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выбрать", for: .normal)
        button.addTarget(self, action: #selector(onTapChoose), for: .touchUpInside)
        button.layer.cornerRadius = 16.0
        return button
    }()

    var onTapChooseButton: (() -> Void)?

    private var didSetupConstraints: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(chooseButton)
        backgroundColor = .white
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //TODO: разобраться почему метод не вызывался, когда footer создается позже
//    override func updateConstraints() {
//        print("here")
//        if !didSetupConstraints {
//            print("SERUPING CONSTRAINTS")
//            setupConstraints()
//            didSetupConstraints = true
//        }
//        super.updateConstraints()
//    }

    @objc private func onTapChoose() {
        onTapChooseButton?()
    }

    func setupButton(isCellSelected: Bool) {
        if(isCellSelected) {
            chooseButton.backgroundColor = Styles.Color.beautifulBlue
            chooseButton.setTitleColor(.white, for: .normal)
            chooseButton.isUserInteractionEnabled = true
        } else {
            chooseButton.backgroundColor = Styles.Color.inactiveGray
            chooseButton.setTitleColor(.gray, for: .normal)
            chooseButton.isUserInteractionEnabled = false
        }
    }

    private func setupConstraints() {
        chooseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chooseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            chooseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chooseButton.heightAnchor.constraint(equalToConstant: 50),
            chooseButton.centerYAnchor.constraint(equalTo: centerYAnchor),

        ])
    }
}

extension FeedFooter: ReusableView {
    static var identifier: String {
        String(describing: self)
    }


}