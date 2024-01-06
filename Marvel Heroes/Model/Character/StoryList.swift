//
//  StoryList.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 19/11/2021.
//

import Foundation

struct StoryList: Codable {

    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [StorySummary]?
}
