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
}

extension FeedInteractor: FeedInteractorInput {
	func load() {
		output?.didLoad()
	}

}
