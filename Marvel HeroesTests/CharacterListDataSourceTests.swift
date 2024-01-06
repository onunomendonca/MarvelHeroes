//
//  CharacterListDataSourceTests.swift
//  Marvel HeroesTests
//
//  Created by Nuno Miguel Mendonça on 22/12/2021.
//

import XCTest
@testable import Marvel_Heroes

class CharacterListDataSourceTests: XCTestCase {

    var apiComunicator = MockComunicator()
    lazy var manager = MockFavouritesManager()
    lazy var dataSource: CharacterListDataSourceProtocol = CharacterListDataSource(comunicator: apiComunicator, manager: manager)
    lazy var exp = expectation(description: "Thor Details")

    // DUMMY VALUES
    let mockChars = MockCharacters()

    // STORAGE
    var characterArray: [CharacterModel] = []
    var filteredArray: [CharacterModel] = []

    override func setUp() {
        dataSource.delegate = self
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        apiComunicator.resetMock()
        manager.resetManager()
    }

    func testGetCharactersFrom0To20() {
        //Given
        apiComunicator.queryResultMock = { offset, limit in
            let charactersList = [self.mockChars.threedman, self.mockChars.abomb]
            return .success(MockDataWrapper.createDataWrapper(charactersList: charactersList))
        }
        //When
        dataSource.getCharacters(from: 0, until: 20)
        //Then
        wait(for: [exp], timeout: 10.0)
        XCTAssertTrue(characterArray[0].name == "3-D Man")
        XCTAssertEqual(characterArray[1].id, 1017100)
        XCTAssertTrue(characterArray.count == 2)
    }

    func testGetCharactersFrom1To20() {
        //Given
        apiComunicator.queryResultMock = { offset, limit in
            let charactersList = [self.mockChars.abomb, self.mockChars.thor]
            return .success(MockDataWrapper.createDataWrapper(charactersList: charactersList))
        }
        //When
        dataSource.getCharacters(from: 1, until: 20)
        //Then
        wait(for: [exp], timeout: 10.0)
        XCTAssertTrue(characterArray[0].name == "A-Bomb (HAS)")
        XCTAssertEqual(characterArray[1].id, 1009664)
    }

    func testGetFilteredCharacterWithSearchTextThor(){
        //Given
        apiComunicator.queryResultMock = { offset, limit in
            let charactersList = [self.mockChars.thor]
            return .success(MockDataWrapper.createDataWrapper(charactersList: charactersList))
        }
        //When
        dataSource.getFilteredCharacter(fromPosition: 0, with: "Thor", until: 20)
        //Then
        wait(for: [exp], timeout: 10.0)
        XCTAssertEqual(filteredArray.count, 1)
        XCTAssertEqual(filteredArray[0].name, "Thor")
    }

    func testGetFilteredCharacterWithSearchTextHenrique(){
        //Given
        apiComunicator.queryResultMock = { offset, limit in
            let charactersList = [self.mockChars.henrique]
            return .success(MockDataWrapper.createDataWrapper(charactersList: charactersList))
        }
        //When
        dataSource.getFilteredCharacter(fromPosition: 0, with: "Henrique", until: 20)
        //Then
        wait(for: [exp], timeout: 10.0)
        XCTAssertEqual(filteredArray.count, 1)
        XCTAssertEqual(filteredArray[0].name, "Henrique")
    }

    func testGetFavouriteArray(){
        //Given
        //When & Then
        XCTAssertEqual(dataSource.getFavouritesArray().count, 0)
        dataSource.toggleFavourite(character: mockChars.henriqueModel)
        XCTAssertEqual(dataSource.getFavouritesArray().last, mockChars.henriqueModel)
        XCTAssertEqual(dataSource.getFavouritesArray().count, 1)
    }

    func testFailMockAPICommunicator(){
        //Given
        XCTExpectFailure("There are no filtered characters to fetch")
        //When
        dataSource.getFilteredCharacter(fromPosition: 0, with: "Henrique", until: 20)
        //Then
        //wait(for: [exp], timeout: 10.0)
        //XCTAssertEqual(filteredArray[0].name, "Henrique2")
    }

//    func testToggleFavourite(){
//        let index:Int? = dataSource.getFavouritesArray().firstIndex(of: char2)
//        XCTAssertNil(index)
//        dataSource.toggleFavourite(character: char3)
//        let index2:Int? = dataSource.getFavouritesArray().firstIndex(of: char2)
//        XCTAssertNotNil(index2)
//        XCTAssertEqual(dataSource.getFavouritesArray().last, char3)
//        dataSource.toggleFavourite(character: char3)
//        let index3:Int? = dataSource.getFavouritesArray().firstIndex(of: char2)
//        XCTAssertNil(index3)
//    }
//
//    func testIsCharacterFavourite(){
//        dataSource.toggleFavourite(character: char2)
//        XCTAssertTrue(dataSource.isCharacterFavourite(character: char2))
//        dataSource.toggleFavourite(character: char2)
//        XCTAssertFalse(dataSource.isCharacterFavourite(character: char2))
//    }

}

extension CharacterListDataSourceTests: CharacterListDataSourceDelegate {
    func charactersDataSource(_ dataSource: CharacterListDataSource, didFetchCharacters: [CharacterModel]) {
        self.characterArray += didFetchCharacters
        exp.fulfill()
    }

    func filteredCharactersDataSource(_ dataSource: CharacterListDataSource, didFetchFilteredCharacters: [CharacterModel], with searchText: String) {
        self.filteredArray += didFetchFilteredCharacters
        exp.fulfill()
    }


}
