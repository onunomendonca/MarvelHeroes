//
//  Comic.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 23/11/2021.
//

import Foundation

struct ComicDataWrapper : Codable {
    let data: ComicDataContainer?
}

struct ComicDataContainer : Codable {
    let results: [Comic]?
}

struct Comic: Detail, Codable {

    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: Image?
    
}
