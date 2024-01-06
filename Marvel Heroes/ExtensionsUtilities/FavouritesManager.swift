//
//  FavouritesManager.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 14/12/2021.
//

import Foundation

protocol ManagerProtocol {
    var favouritesArray:[CharacterModel] { get }
    func addNewFavourite(character: CharacterModel)
    func removeFavourite(character: CharacterModel)
    func isCharacterFavourite(character: CharacterModel) -> Bool
}

class FavouritesManager: ManagerProtocol{

    private var localMemoryDB: MemoryDBProtocol
    var favouritesArray:[CharacterModel]

    init(memoryDB : MemoryDBProtocol) {
        self.localMemoryDB = memoryDB
        self.favouritesArray = localMemoryDB.fetchFavouritesFromMemory()
    }

    func addNewFavourite(character: CharacterModel){
        favouritesArray.append(character)
        saveInMemory()
    }

    func removeFavourite(character: CharacterModel){
        guard let index = favouritesArray.firstIndex(of: character) else {
            return
        }
        favouritesArray.remove(at: index)
        saveInMemory()
    }

    func isCharacterFavourite(character: CharacterModel) -> Bool {
        guard let _ = favouritesArray.firstIndex(of: character) else {
            return false
        }
        return true
    }

    private func saveInMemory(){
        localMemoryDB.saveFavourites(characters: favouritesArray)
    }


}
