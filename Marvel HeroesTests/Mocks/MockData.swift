//
//  MockData.swift
//  Marvel HeroesTests
//
//  Created by Nuno Miguel Mendonça on 06/01/2022.
//

import Foundation
import OSLog
@testable import Marvel_Heroes

struct MockData {

    func loadJsonAndReturnData() -> Data? {

        if let url = Bundle.main.url(forResource: "mockDataSuccess", withExtension: "json", subdirectory: "MockFiles") {
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch {
                os_log("error:\(error)")
            }
        }
        return nil
    }

    func loadJsonAndReturnThorFilteredData() -> Data? {

        if let url = Bundle.main.url(forResource: "mockDataFilteredThorSuccess", withExtension: "json", subdirectory: "MockFiles")
        {
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch {
                os_log("error:\(error)")
            }
        }
        return nil
    }

    func loadDetailsJsonsAndReturnThorDetailModel() -> DetailsModel? {
        return ThorDetailModelMock.detailsModel
    }
}
