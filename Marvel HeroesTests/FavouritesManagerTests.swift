//
//  FavouritesManagerTests.swift
//  Marvel HeroesTests
//
//  Created by Nuno Miguel Mendonça on 23/12/2021.
//

import XCTest
@testable import Marvel_Heroes

class FavouritesManagerTest: XCTestCase {

    var manager = MockFavouritesManager()
    let char1 = CharacterModel(id: 101, name: "Nuno", description: nil, thumbnail: nil)

    func testAddNewFavourite(){
        //Given
        manager.resetManager()
        //When
        let numberOfFavourites = manager.favouritesArray.count
        manager.addNewFavourite(character: char1)
        //Then
        XCTAssertEqual(manager.favouritesArray.count, numberOfFavourites + 1)
        XCTAssertEqual(manager.favouritesArray.last, char1)
    }

    func testRemoveFavourite(){
        //Given
        manager.resetManager()
        //When
        manager.addNewFavourite(character: char1)
        let numberOfFavourites = manager.favouritesArray.count
        manager.removeFavourite(character: char1)
        //Then
        XCTAssertEqual(manager.favouritesArray.count, numberOfFavourites - 1)
    }

    func testIsCharacterFavourite() {
        //Given
        manager.resetManager()
        //When & Then
        manager.addNewFavourite(character: char1)
        XCTAssertTrue(manager.isCharacterFavourite(character: char1))
        manager.removeFavourite(character: char1)
        XCTAssertFalse(manager.isCharacterFavourite(character: char1))
    }
}
