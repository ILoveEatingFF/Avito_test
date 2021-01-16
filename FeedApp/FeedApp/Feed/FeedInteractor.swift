//
//  FeedInteractor.swift
//  FeedApp
//
//  Created by Иван Лизогуб on 13.01.2021.
//  
//

import Foundation

final class FeedInteractor {
	weak var output: FeedInteractorOutput?
	private let path = Bundle.main.path(forResource: "result", ofType: "json")
}

extension FeedInteractor: FeedInteractorInput {
	func load() {
		if let path = path {
			let fileUrl = URL(fileURLWithPath: path)
			do {
				let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
				let decoder = JSONDecoder()
				let decodedObject = try decoder.decode(Main.self, from: data)
				output?.didLoad(decodedObject.upgrades)
			} catch let error {
				print("Ошибка парсинга json файла:", error as Any)
			}
		}
	}

}
