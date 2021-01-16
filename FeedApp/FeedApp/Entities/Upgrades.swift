//
// Created by Иван Лизогуб on 16.01.2021.
//

import Foundation


struct Main: Codable {
    let status: String
    let upgrades: Upgrades

    enum CodingKeys: String, CodingKey {
        case status
        case upgrades = "result"
    }
}

struct Upgrades: Codable {

    enum CodingKeys: String, CodingKey {
        case actionTitle, selectedActionTitle
        case sectionTitle = "title"
        case upgrades = "list"
    }

    let sectionTitle: String
    let actionTitle: String
    let selectedActionTitle: String
    let upgrades: [Upgrade]
}

struct Upgrade: Codable {
    let id: String
    let title: String
    let description: String?
    let icon: Icon
    let price: String
    let isSelected: Bool
}

struct Icon: Codable {
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case imageUrl = "52x52"
    }
}
