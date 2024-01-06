//
//  LocalMemoryDB.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 14/12/2021.
//

import Foundation
import OSLog

protocol MemoryDBProtocol {
    func fetchFavouritesFromMemory() -> [CharacterModel]
    func saveFavourites(characters: [CharacterModel])
}

//Manages what is on device's memory.
class LocalMemoryDB: MemoryDBProtocol {
    
    func fetchFavouritesFromMemory() -> [CharacterModel]{
        if let data = UserDefaults.standard.data(forKey: "favourites") {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([CharacterModel].self, from: data)
            } catch {
                os_log("Unable to Decode Favourites Characters: (\(error))")
            }
        }
        return []
    }
    
    func saveFavourites(characters: [CharacterModel]){
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(characters)
            UserDefaults.standard.set(data, forKey: "favourites")
        } catch {
            os_log("Unable to Encode Favourites Characters: (\(error))")
        }
    }
}
