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

    private let chooseButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Styles.Color.inactiveGray
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(onTapChoose), for: .touchUpInside)
        button.layer.cornerRadius = 16.0
        return button
    }()

    init(output: FeedViewOutput) {
        self.output = output
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(chooseButton)
        self.view = view
        setupCollectionView()
        setupExitButton()
        setupConstraints()
    }

	override func viewDidLoad() {
		super.viewDidLoad()
        output.viewDidLoad()
	}

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionViewLayout.estimatedItemSize = CGSize(width: collectionView.frame.width - Constants.widthPadding, height: 230)
        collectionViewLayout.itemSize = CGSize(width: collectionView.frame.width - Constants.widthPadding, height: UICollectionViewFlowLayout.automaticSize.height)
    }
}

extension FeedViewController: FeedViewInput {
    func set(with viewModels: [ViewModel], sectionTitle: String, actionTitle: String, selectedActionTitle: String) {
        self.sectionTitle = sectionTitle
        self.viewModels = viewModels
        self.actionTitle = actionTitle
        chooseButton.setTitle(actionTitle, for: .normal)
        self.selectedActionTitle = selectedActionTitle
        collectionView.reloadData()
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let cell = collectionView.cellForItem(at: indexPath) as? FeedViewCell {
            if cell.isSelected {
                chooseButton.setTitle(actionTitle, for: .normal)
                chooseButton.backgroundColor = Styles.Color.inactiveGray
                chooseButton.setTitleColor(.gray, for: .normal)
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            } else {
                chooseButton.setTitle(selectedActionTitle, for: .normal)
                chooseButton.backgroundColor = Styles.Color.beautifulBlue
                chooseButton.setTitleColor(.white, for: .normal)
                return true
            }
        }
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
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 100)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15.0
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
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 16, bottom: 90, right: 16.0)
    }

    func setupExitButton() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = exitButton
    }

    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        chooseButton.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),

            chooseButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20.0),
            chooseButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16.0),
            chooseButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16.0),
            chooseButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }

    @objc func onTapChoose() {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        let viewModel = viewModels[indexPath.item]

        output.onTapChoose(with: viewModel.title)

    }
}