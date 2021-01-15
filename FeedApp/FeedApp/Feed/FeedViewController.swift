//
//  FeedViewController.swift
//  FeedApp
//
//  Created by Иван Лизогуб on 13.01.2021.
//  
//

import UIKit

final class FeedViewController: UIViewController {
	private let output: FeedViewOutput

    private var viewModels: [ViewModel] = []
    private var sectionTitle: String = ""
    private let collectionView: UICollectionView
    private let collectionViewLayout = UICollectionViewFlowLayout()

    private let exitButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "cross")
        button.setImage(image, for: .normal)
        let buttonItem = UIBarButtonItem(customView: button)
        return buttonItem
    }()
    
    private var setupButtonFunction = false
    private var cellIsSelected = false

    init(output: FeedViewOutput) {
        self.output = output
        collectionViewLayout.scrollDirection = .vertical
//        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()
        view.addSubview(collectionView)
        self.view = view
        setupCollectionView()
        setupExitButton()
        setupConstraints()
    }

	override func viewDidLoad() {
		super.viewDidLoad()

        output.viewDidLoad()
	}
}

extension FeedViewController: FeedViewInput {
    func set(with viewModels: [ViewModel], sectionTitle: String) {
        self.sectionTitle = sectionTitle
        self.viewModels = viewModels
        collectionView.reloadData()
    }

}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let footer = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter,
                at: IndexPath(item: 0, section: 0)) as? FeedFooter

        if let cell = collectionView.cellForItem(at: indexPath) as? FeedViewCell {
            if cell.isSelected {
                cellIsSelected = false
                footer?.chooseButton.backgroundColor = Styles.Color.inactiveGray
                footer?.chooseButton.setTitleColor(.gray, for: .normal)
                footer?.chooseButton.isUserInteractionEnabled = false
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            } else {
                cellIsSelected = true
                footer?.chooseButton.isUserInteractionEnabled = true
                footer?.chooseButton.backgroundColor = Styles.Color.beautifulBlue
                footer?.chooseButton.setTitleColor(.white, for: .normal)
                return true
            }
        }
        cellIsSelected = false
        return false
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = viewModels[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedViewCell.identifier, for: indexPath) as! FeedViewCell
        cell.update(with: viewModel)
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: FeedHeader.identifier,
                    for: indexPath
            ) as! FeedHeader
            headerView.setTitleText(with: sectionTitle)
            return headerView
        case UICollectionView.elementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: FeedFooter.identifier,
                        for: indexPath
                ) as! FeedFooter
            if !setupButtonFunction {
                footerView.onTapChooseButton = {[weak self] in
                    self?.onTapChoose()
                }
                setupButtonFunction = !setupButtonFunction
            }
            footerView.setupButton(isCellSelected: cellIsSelected)
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio: CGFloat = 0.6
        let width = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        let height = width * ratio
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let ratio: CGFloat = 0.3
        let width = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        let height = ratio * width
         return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        let ratio: CGFloat = 0.3
        let width = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        let height = ratio * width
        return CGSize(width: width, height: height)
    }
}

private extension FeedViewController {
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(FeedViewCell.self, forCellWithReuseIdentifier: FeedViewCell.identifier)
        collectionView.register(FeedHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: FeedHeader.identifier)
        collectionView.register(FeedFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: FeedFooter.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 40, left: 16, bottom: 200, right: 16)
        collectionView.canCancelContentTouches = true
    }

    func setupExitButton() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = exitButton
    }

    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }

    @objc func onTapChoose() {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        let viewModel = viewModels[indexPath.item]

        output.onTapChoose(with: viewModel.title)

    }
}