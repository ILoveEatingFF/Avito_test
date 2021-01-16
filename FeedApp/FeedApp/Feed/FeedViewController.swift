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
    private var actionTitle: String = ""
    private var selectedActionTitle: String = ""
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    private lazy var collectionViewLayout = {
        setupLayout()
    }()

    private let exitButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.isUserInteractionEnabled = false
        let image = UIImage(named: "cross")
        button.setImage(image, for: .normal)
        let buttonItem = UIBarButtonItem(customView: button)
        return buttonItem
    }()

    private var cellIsSelected = false

    init(output: FeedViewOutput) {
        self.output = output
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

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}

extension FeedViewController: FeedViewInput {
    func set(with viewModels: [ViewModel], sectionTitle: String, actionTitle: String, selectedActionTitle: String) {
        self.sectionTitle = sectionTitle
        self.viewModels = viewModels
        self.actionTitle = actionTitle
        self.selectedActionTitle = selectedActionTitle
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
                footer?.chooseButton.setTitle(actionTitle, for: .normal)
                footer?.chooseButton.backgroundColor = Styles.Color.inactiveGray
                footer?.chooseButton.setTitleColor(.gray, for: .normal)
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            } else {
                cellIsSelected = true
                footer?.chooseButton.setTitle(selectedActionTitle, for: .normal)
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
                footerView.onTapChooseButton = { [weak self] in
                    self?.onTapChoose()
                }
            footerView.setupButton(isCellSelected: cellIsSelected, actionTitle: actionTitle,
                    selectedActionTitle: selectedActionTitle)
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
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
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    }

    func setupLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0),
                heightDimension: NSCollectionLayoutDimension.estimated(230)
        )

        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16)
        section.interGroupSpacing = 20

        let headerFooterSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(140)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
        )

        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerFooterSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
        )

        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func setupExitButton() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = exitButton
    }

    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
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