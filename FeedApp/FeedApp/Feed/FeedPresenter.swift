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

extension FeedPresenter: FeedInteractorOutput {
    func didLoad() {
        let viewModels = makeViewModels()
        let sectionTitle = "Сделайте объявление заметнее на 7 дней"
        view?.set(with: viewModels, sectionTitle: sectionTitle)
    }

}

private extension FeedPresenter {
    func makeViewModels() -> [ViewModel] {
        var result: [ViewModel] = []
        result.append(ViewModel(image: "lel", title: "XL-объявление",
                description: "Пользователи смогут посмотреть фотографии, описание и телефон прямо из результатов поиска",
                cost: "356 ₽"))
        result.append(ViewModel(
                image: "kek",
                title: "Выделить цветом",
                description: "Яркий цвет не даст затеряться среди других объявлений",
                cost: "299 ₽"))
        result.append(ViewModel(
                image: "ROR",
                title: "Жесть",
                description: "Самая жесткая жестокая жесткость просто жесть как жестко",
                cost: "110"))
        return result
    }
}
