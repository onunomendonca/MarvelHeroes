//
//  Hero.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 17/11/2021.
//

import Foundation
import UIKit

struct Character: Codable{
    
    let id: Int?
    let name: String?
    let description: String?
    let modified: Date?
    let resourceURI:String?
    let urls: [Url]?
    let thumbnail: Image?
    let comics: ComicList?
    let stories: StoryList?
    let events: EventList?
    let series: SeriesList?
}
