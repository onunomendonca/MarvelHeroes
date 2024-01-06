//
//  CharacterDataWrapper.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 19/11/2021.
//

import Foundation

struct CharacterDataWrapper: Codable {

    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let data: CharacterDataContainer?
    let etag: String?

}
