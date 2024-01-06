//
//  ViewControllerFactory.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 07/12/2021.
//

import Foundation

class ViewControllerFactory {

    private let comunicator: CommunicatorProtocol
    private let manager: ManagerProtocol

    init(comunicator: CommunicatorProtocol, manager: ManagerProtocol) {
        self.comunicator = comunicator
        self.manager = manager
    }

    func createCharacterListVC() -> CharacterListViewController {
        let characterListDS: CharacterListDataSourceProtocol = CharacterListDataSource(comunicator: comunicator, manager: manager)
        return CharacterListViewController(vcFactory: self, dataSource: characterListDS)
    }

    func createDetailVC(character: CharacterModel) -> DetailsViewController{
        let detailsDS: DetailsDataSourceProtocol = DetailsDataSource(comunicator: comunicator, manager: manager)
        return DetailsViewController(character: character, dataSource: detailsDS)
    }

}
