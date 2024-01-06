//
//  MockComunicator.swift
//  Marvel HeroesTests
//
//  Created by Nuno Miguel Mendonça on 23/12/2021.
//

import Foundation
@testable import Marvel_Heroes
import XCTest

class MockComunicator: CommunicatorProtocol {

    var queryResultMock: ( (_ offset: Int,_ limit: Int) -> Result<CharacterDataWrapper, GError>)?
    var queryDetailMock: ( () -> Result<DetailsModel, GError>)?

    func resetMock(){
        queryResultMock = nil
        queryDetailMock = nil
    }

    func getCharacterData(fromPosition offset: Int, until limit: Int, completion: @escaping CharacterQueryResult) {
        guard let queryResultMock = queryResultMock?(offset,limit) else {
            XCTFail("There are no characters to fetch")
            return
        }
        completion(queryResultMock)
    }

    func getFilteredCharacterData(fromPosition offset: Int, until limit: Int, withFilter text: String, completion: @escaping CharacterQueryResult) {
        guard let queryResultMock = queryResultMock?(offset, limit) else {
            XCTFail("There are no filtered characters to fetch")
            return
        }
        completion(queryResultMock)
    }

    func getDetails(character: CharacterModel, completion: @escaping DetailsModelQueryResult) {
        guard let queryDetailMock = queryDetailMock?() else {
            XCTFail("There are no details to fetch")
            return
        }
        completion(queryDetailMock)
    }
}
