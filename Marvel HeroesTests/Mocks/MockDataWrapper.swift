//
//  MockDataWrapper.swift
//  Marvel HeroesTests
//
//  Created by Nuno Miguel Mendonça on 03/01/2022.
//

import Foundation
@testable import Marvel_Heroes

struct MockDataWrapper {

    static func createDataWrapper(charactersList: [Character]) -> CharacterDataWrapper{
        let dataContainer = CharacterDataContainer(offset: 0, limit: 20, total: charactersList.count, count: nil, results: charactersList)
        let dataWrapper: CharacterDataWrapper = CharacterDataWrapper(code: nil, status: nil, copyright: nil, attributionText: nil, attributionHTML: nil, data: dataContainer, etag: nil)
        return dataWrapper
    }
}
