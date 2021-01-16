//
//  FeedProtocols.swift
//  FeedApp
//
//  Created by Иван Лизогуб on 13.01.2021.
//  
//

import Foundation

protocol ReusableView {
	static var identifier: String { get }
}

protocol FeedModuleInput {
	var moduleOutput: FeedModuleOutput? { get }
}

protocol FeedModuleOutput: class {
}

protocol FeedViewInput: class {
	func set(with viewModels: [ViewModel], sectionTitle: String, actionTitle: String, selectedActionTitle: String)
}

protocol FeedViewOutput: class {
	func viewDidLoad()
	func onTapChoose(with title: String)
}

protocol FeedInteractorInput: class {
	func load()
}

protocol FeedInteractorOutput: class {
	func didLoad(_ upgrades: Upgrades)
}

protocol FeedRouterInput: class {
	func showAlert(with title: String)
}
