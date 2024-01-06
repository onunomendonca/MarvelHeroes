//
//  DetailsModel.swift
//  Marvel Heroes
//
//  Created by Nuno Miguel Mendonça on 23/11/2021.
//

import Foundation

protocol Detail {

    var title: String? { get }
    var description: String? { get }
    var thumbnail: Image? { get }
}

struct DetailsModel {

    let characterId: Int
    let comics: [Comic]
    let events: [Event]
    let series: [Series]
    let stories: [Story]

    init(characterId: Int, comics: [Comic], events: [Event], series: [Series], stories: [Story]) {
        self.characterId = characterId
        self.comics = comics
        self.events = events
        self.series = series
        self.stories = stories
    }
}
