//
//  Story.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 23/11/2021.
//

import Foundation

struct StoryDataWrapper : Codable {
    let data: StoryDataContainer?
}

struct StoryDataContainer : Codable {
    let results: [Story]?
}

struct Story : Detail, Codable {

    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: Image?
}
