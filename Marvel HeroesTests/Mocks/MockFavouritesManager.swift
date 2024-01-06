//
//  MockFavouritesManager.swift
//  Marvel HeroesTests
//
//  Created by Nuno Miguel Mendonça on 31/12/2021.
//

import Foundation
@testable import Marvel_Heroes

class MockFavouritesManager: ManagerProtocol{

    var favouritesArray:[CharacterModel] = []

    func resetManager(){
        favouritesArray = []
    }

    func addNewFavourite(character: CharacterModel){
        favouritesArray.append(character)
    }

    func removeFavourite(character: CharacterModel){
        guard let index = favouritesArray.firstIndex(of: character) else {
            return
        }
        favouritesArray.remove(at: index)
    }

    func isCharacterFavourite(character: CharacterModel) -> Bool {
        guard let _ = favouritesArray.firstIndex(of: character) else {
            return false
        }
        return true
    }
}
