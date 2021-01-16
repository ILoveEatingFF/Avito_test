//
//  FeedPresenter.swift
//  FeedApp
//
//  Created by Иван Лизогуб on 13.01.2021.
//  
//

import Foundation

final class FeedPresenter {
	weak var view: FeedViewInput?
    weak var moduleOutput: FeedModuleOutput?
    
	private let router: FeedRouterInput
	private let interactor: FeedInteractorInput
    
    init(router: FeedRouterInput, interactor: FeedInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension FeedPresenter: FeedModuleInput {
}

extension FeedPresenter: FeedViewOutput {
    func viewDidLoad() {
        interactor.load()
    }

    func onTapChoose(with title: String) {
        router.showAlert(with: title)
    }

}

// Не понятно, что делать с параметром isSelected, в макете отсутствуют апгрейды с isSelected = false, поэтому создал для этого фильтр
extension FeedPresenter: FeedInteractorOutput {
    func didLoad(_ upgrades: Upgrades) {
        let viewModels = makeViewModels(upgrades.upgrades)
        let filteredViewModels = filterIsSelectedViewModels(viewModels, isSelected: true)
        let sectionTitle = upgrades.sectionTitle
        view?.set(with: filteredViewModels, sectionTitle: sectionTitle, actionTitle: upgrades.actionTitle,
                selectedActionTitle: upgrades.selectedActionTitle)
        // Раскоментить, если фильтр на isSelected не нужен
//        view?.set(with: viewModels, sectionTitle: sectionTitle, actionTitle: upgrades.actionTitle,
//                selectedActionTitle: upgrades.selectedActionTitle)

    }

}

private extension FeedPresenter {
    func makeViewModels(_ upgrades: [Upgrade]) -> [ViewModel] {
        upgrades.map { upgrade in
            ViewModel(
                    imageUrl: upgrade.icon.imageUrl,
                    title: upgrade.title,
                    description: upgrade.description ?? "",
                    cost: upgrade.price,
                    isSelected: upgrade.isSelected
            )
        }
    }

    func filterIsSelectedViewModels(_ viewModels: [ViewModel], isSelected: Bool) -> [ViewModel] {
        viewModels.filter { $0.isSelected == isSelected  }
    }
}
