//
//  CharacterModel.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 10/12/2021.
//

import Foundation

struct CharacterModel: Equatable, Codable {
    static func == (lhs: CharacterModel, rhs: CharacterModel) -> Bool {
        lhs.id == rhs.id
    }

    let id: Int
    let name: String
    let description: String?
    let thumbnail: Image?


    init( id: Int, name: String, description:String?, thumbnail:Image?) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
    }
}
