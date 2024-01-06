//
//  DetailsDataSourceTests.swift
//  Marvel HeroesTests
//
//  Created by Nuno Miguel Mendonça on 22/12/2021.
//

import XCTest
@testable import Marvel_Heroes

class DetailsDataSourceDelegateMock: DetailsDataSourceDelegate {

    var stubFetchDetails: ( (DetailsModel) -> () )?

    func detailsDataSource(_ dataSource: DetailsDataSource, didFetchDetails: DetailsModel) {
        stubFetchDetails?(didFetchDetails)
    }
}

class DetailsDataSourceTests: XCTestCase {

    //Given
    var apiComunicator = MockComunicator()
    var manager = MockFavouritesManager()
    lazy var dataSource: DetailsDataSourceProtocol = DetailsDataSource(comunicator: apiComunicator, manager: manager)

    var delegateMock: DetailsDataSourceDelegateMock!
    let charMocks = MockCharacters()
    let mockDetails = MockDetails()

    //Dummy Characters
    let char1 = CharacterModel(id: 101, name: "Nuno", description: nil, thumbnail: nil)
    let char2 = CharacterModel(id: 999, name: "Henrique", description: "SuperMentor", thumbnail: nil)
    let char3 = CharacterModel(id: 001, name: "José Neves", description: "CEO", thumbnail: nil)

    override func setUp() {
        delegateMock = DetailsDataSourceDelegateMock()
        dataSource.delegate = delegateMock
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        delegateMock = nil
        apiComunicator.resetMock()
        manager.resetManager()
    }

    func testGetFavouriteArray(){
        //Given
        //When & Then
        XCTAssertEqual(dataSource.getFavouritesArray().count, 0)
        dataSource.toggleFavourite(character: char3)
        XCTAssertEqual(dataSource.getFavouritesArray().last, char3)
        XCTAssertEqual(dataSource.getFavouritesArray().count, 1)
    }

    func testToggleFavourite(){
        let index:Int? = dataSource.getFavouritesArray().firstIndex(of: char3)
        XCTAssertNil(index)
        dataSource.toggleFavourite(character: char3)
        let index2:Int? = dataSource.getFavouritesArray().firstIndex(of: char3)
        XCTAssertNotNil(index2)
        XCTAssertEqual(dataSource.getFavouritesArray().last, char3)
        dataSource.toggleFavourite(character: char3)
        let index3:Int? = dataSource.getFavouritesArray().firstIndex(of: char3)
        XCTAssertNil(index3)
    }

    func testGetDetailsData() {
        //Given
        let expectation = expectation(description: "Get Thor Details")
        apiComunicator.queryDetailMock = {
            return .success(self.mockDetails.thorDetails)
        }
        delegateMock.stubFetchDetails = { detailModel in
            XCTAssertEqual(detailModel.comics.count, 3)
            XCTAssertEqual(detailModel.comics[1].title, "Thor by Donny Cates Vol. 3: Revelations (Trade Paperback)")
            XCTAssertEqual(detailModel.series.count, 3)
            XCTAssertEqual(detailModel.series[1].title, "Age of Heroes (2010)")
            XCTAssertEqual(detailModel.stories.count, 3)
            XCTAssertEqual(detailModel.stories[1].title, "Interior #877")
            XCTAssertEqual(detailModel.events.count, 3)
            XCTAssertEqual(detailModel.events[1].title, "Atlantis Attacks")
            expectation.fulfill()
        }
        //When
        dataSource.getDetailsData(for: charMocks.thorModel)
        wait(for: [expectation], timeout: 10.0)
    }

    func testIsCharacterFavourite(){
        dataSource.toggleFavourite(character: char3)
        XCTAssertTrue(dataSource.isCharacterFavourite(character: char3))
        dataSource.toggleFavourite(character: char3)
        XCTAssertFalse(dataSource.isCharacterFavourite(character: char3))
    }
}
