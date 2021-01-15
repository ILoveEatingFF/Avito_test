//
// Created by Иван Лизогуб on 13.01.2021.
//

import UIKit

class FeedViewCell: UICollectionViewCell {

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    private lazy var informationStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            title,
            contentDescription,
            cost
        ])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        return stack
    }()

    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 26)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private let contentDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private let cost: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private let isSelectedImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "checkmark"))
        imageView.contentMode = .scaleAspectFill
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.isHidden = true
        return imageView
    }()

    override var isSelected: Bool {
        didSet {
            if isSelected {
                isSelectedImageView.isHidden = false
            } else {
                isSelectedImageView.isHidden = true
            }
        }
    }


    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        setupConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("not implemented")
    }

    private func setup() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(iconImageView)
        contentView.addSubview(informationStackView)
        contentView.addSubview(isSelectedImageView)
    }

    private func setupConstraints() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        informationStackView.translatesAutoresizingMaskIntoConstraints = false
        isSelectedImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),

            informationStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            informationStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            informationStackView.trailingAnchor.constraint(equalTo: isSelectedImageView.leadingAnchor,constant: -20),
            informationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            isSelectedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            isSelectedImageView.centerYAnchor.constraint(equalTo: title.centerYAnchor,constant: 10),
        ])
    }

//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        super.preferredLayoutAttributesFitting(layoutAttributes)
//    }

    func update(with viewModel: ViewModel) {
//        iconImageView.image = UIImage(named: viewModel.image)
        iconImageView.image = UIImage(named: "cross")
        title.text = viewModel.title
        contentDescription.attributedText = makeLabelTextWithSpacing(text: viewModel.description)
        cost.text = viewModel.cost
    }
}

extension FeedViewCell: ReusableView {
    static var identifier: String {
        String(describing: self)
    }
}

private extension FeedViewCell {
    func makeLabelTextWithSpacing(text: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(
                NSAttributedString.Key.paragraphStyle,
                value: paragraphStyle,
                range: NSMakeRange(0, attributedString.length)
        )
        return attributedString
    }
}