//
//  Series.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 23/11/2021.
//

import Foundation

struct SeriesDataWrapper : Codable {
    let data: SeriesDataContainer?
}

struct SeriesDataContainer : Codable {
    let results: [Series]?
}


struct Series : Detail, Codable {

    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: Image?
}
