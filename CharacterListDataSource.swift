//
//  CharacterListDataSource.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 09/12/2021.
//

import Foundation

protocol CharacterListDataSourceProtocol {

    var delegate: CharacterListDataSourceDelegate? { get set }
    var maxNumberOfCharacter: Int? { get }

    func getCharacters(from offset: Int, until limit: Int)
    func getFilteredCharacter(fromPosition offset:Int, with searchText:String, until limit: Int)
    func getFavouritesArray() -> [CharacterModel]
    func toggleFavourite(character: CharacterModel) 
    func isCharacterFavourite(character: CharacterModel) -> Bool
}

protocol CharacterListDataSourceDelegate: AnyObject {

    func charactersDataSource( _ dataSource: CharacterListDataSource, didFetchCharacters: [CharacterModel])
    func filteredCharactersDataSource (_ dataSource: CharacterListDataSource, didFetchFilteredCharacters: [CharacterModel], with searchText: String)

}

class CharacterListDataSource: CharacterListDataSourceProtocol {

    var maxNumberOfCharacter: Int?
    weak var delegate: CharacterListDataSourceDelegate?
    private var comunicator: CommunicatorProtocol
    private var manager: ManagerProtocol
    private var lastSearchedWord: String = ""

    init(comunicator: CommunicatorProtocol, manager: ManagerProtocol){
        self.comunicator = comunicator
        self.manager = manager
    }

    func getCharacters(from offset: Int, until limit: Int) {

        self.comunicator.getCharacterData(fromPosition: offset, until: limit) { result in

            switch result {

            case .success(let characterDataWrapper):
                self.maxNumberOfCharacter = characterDataWrapper.data?.total
                guard let characterArray = characterDataWrapper.data?.results else {
                    return
                }
                let characterModelArray = characterArray.compactMap { character -> CharacterModel? in
                    guard let id = character.id,
                       let name = character.name  else {
                        return nil
                    }
                    return CharacterModel(id: id, name: name, description: character.description, thumbnail: character.thumbnail)
                }

                self.delegate?.charactersDataSource(self, didFetchCharacters: characterModelArray)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }

    func getFilteredCharacter(fromPosition offset:Int, with searchText:String, until limit: Int){

        self.comunicator.getFilteredCharacterData(fromPosition: offset, until: limit, withFilter: searchText) { result in

            switch result {

            case .success(let characterDataWrapper):
                
                guard let charactersArray = characterDataWrapper.data?.results else {
                    return
                }
                let characterModelArray: [CharacterModel] = charactersArray.compactMap { character in
                    guard let id = character.id,
                       let name = character.name  else {
                        return nil
                    }
                    return CharacterModel(id: id, name: name, description: character.description, thumbnail: character.thumbnail)
                }
                self.delegate?.filteredCharactersDataSource(self, didFetchFilteredCharacters: characterModelArray, with: searchText)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }

    func getFavouritesArray() -> [CharacterModel] {

        manager.favouritesArray
    }

    func toggleFavourite(character: CharacterModel) {

        if manager.isCharacterFavourite(character: character){
            self.manager.removeFavourite(character: character)
        } else {
            self.manager.addNewFavourite(character: character)
        }

    }

    func isCharacterFavourite(character: CharacterModel) -> Bool {
        
        return manager.isCharacterFavourite(character: character)
    }

}
