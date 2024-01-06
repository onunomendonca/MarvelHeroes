//
//  Event.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 23/11/2021.
//

import Foundation

struct EventDataWrapper : Codable {
    let data: EventDataContainer?
}

struct EventDataContainer : Codable {
    let results: [Event]?
}

struct Event: Detail, Codable {

    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: Image?
}
