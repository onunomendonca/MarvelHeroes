//
//  DetailsDataSource.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 07/12/2021.
//

import Foundation

protocol DetailsDataSourceProtocol {

    var delegate: DetailsDataSourceDelegate? { get set }

    func getDetailsData(for character: CharacterModel)
    func getFavouritesArray() -> [CharacterModel]
    func toggleFavourite(character: CharacterModel)
    func isCharacterFavourite(character: CharacterModel) -> Bool
    
}

protocol DetailsDataSourceDelegate: AnyObject {
    func detailsDataSource( _ dataSource: DetailsDataSource, didFetchDetails: DetailsModel)
}

class DetailsDataSource: DetailsDataSourceProtocol {

    weak var delegate: DetailsDataSourceDelegate?

    private var comunicator: CommunicatorProtocol
    private var manager: ManagerProtocol

    init(comunicator: CommunicatorProtocol, manager: ManagerProtocol) {
        self.comunicator = comunicator
        self.manager = manager
    }

    func getDetailsData(for character: CharacterModel){
        comunicator.getDetails(character: character, completion: { result in
            switch result {
            case .success(let detailsModel):
                self.delegate?.detailsDataSource(self, didFetchDetails: detailsModel)
            case .failure(let error):
                print(error.rawValue)
            }
        })
    }

    func getFavouritesArray() -> [CharacterModel] {
        manager.favouritesArray
    }

    func toggleFavourite(character: CharacterModel) {
        if manager.isCharacterFavourite(character: character){
            manager.removeFavourite(character: character)
        } else {
            manager.addNewFavourite(character: character)
        }
    }

    func isCharacterFavourite(character: CharacterModel) -> Bool {
        return manager.isCharacterFavourite(character: character)
    }

}
