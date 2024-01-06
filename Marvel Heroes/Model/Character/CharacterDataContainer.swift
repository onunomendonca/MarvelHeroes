//
//  CharacterDataContainer.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 19/11/2021.
//

import Foundation

struct CharacterDataContainer: Codable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [Character]?
}
