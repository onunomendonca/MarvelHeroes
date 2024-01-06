//
//  APICommunicatorTests.swift
//  Marvel HeroesTests
//
//  Created by Nuno Miguel Mendonça on 23/12/2021.
//

import XCTest
@testable import Marvel_Heroes

class APICommunicatorTests: XCTestCase {

    //Given
    let mockSession = URLSessionMock()
    let mockchars = MockCharacters()
    let mockDetails = MockDetails()
    lazy var api = APICommunicator(defaultSession: mockSession)
    lazy var exp_filtered = expectation(description: "Get Filtered Characters")
    lazy var exp_details = expectation(description: "Get Details Model from Character")

    func testInvalidDataResponseWithNoData() {

        //Given
        let exp = expectation(description: "Failure invalid Response")
        var result: Result<CharacterDataWrapper, GError>?
        //When
        api.getCharacterData(fromPosition: 0, until: 20) {

            result = $0
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
        //Then
        switch result {
        case .success(_):
            XCTFail("Expected to be a failure Invalid Response but got a success")
        case .failure(let error):
            XCTAssertEqual(.invalidResponse, error)
        case .none:
            XCTFail("Expected to be a failure but got a none")
        }

    }

    func testSuccessfulResponse() {

        // Given
        let exp = expectation(description: "Successful Answer")

        // When
        let data = MockData().loadJsonAndReturnData()
        let response = HTTPURLResponse(url: URL(fileURLWithPath: "MockData"), statusCode: 200, httpVersion: "1.1", headerFields: nil)
        mockSession.prepareSession(data: data, response: response, error: nil)

        var result: Result<CharacterDataWrapper, GError>?
        api.getCharacterData(fromPosition: 0, until: 20) {

            result = $0
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)

        switch result {
        case .success(let charDatawrapper):
            XCTAssertEqual(charDatawrapper.data?.results?[0].id, 1011334)
        case .failure(let error):
            XCTFail("Expected to be a success but got a failure with \(error)")
        case .none:
            XCTFail("Expected to be a success but got a none")
        }
    }


    func testGetFilteredDataThorWithSuccess(){

        //Given
        let exp_filtered = expectation(description: "Successful Filtered Answer")
        let data = MockData().loadJsonAndReturnThorFilteredData()
        let response = HTTPURLResponse(url: URL(fileURLWithPath: "MockData"), statusCode: 200, httpVersion: "1.1", headerFields: nil)
        mockSession.prepareSession(data: data, response: response, error: nil)

        var result: Result<CharacterDataWrapper, GError>?
        //When
        api.getFilteredCharacterData(fromPosition: 0, until: 20, withFilter: "Thor") {

            result = $0
            exp_filtered.fulfill()
        }
        wait(for: [exp_filtered], timeout: 10.0)
        //Then
        switch result{
        case .success(let data):
            XCTAssertTrue(data.data?.results?[0].name == "Thor")
        case .failure(let error):
            XCTFail("Failed getting the data out of filtered characters with \(error)")
        case .none:
            XCTFail("Expected to be a success but got a none")
        }
    }
}
