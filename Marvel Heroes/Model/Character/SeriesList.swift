//
//  SeriesList.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 19/11/2021.
//

import Foundation

struct SeriesList: Codable {

    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [SeriesSummary]?
}
