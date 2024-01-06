//
//  MockCharacters.swift
//  Marvel HeroesTests
//
//  Created by Nuno Miguel Mendonça on 31/12/2021.
//

import Foundation
@testable import Marvel_Heroes

public struct MockCharacters {

    let thor = Character(id: 1009664, name: "Thor", description: "As the Norse God of thunder and lightning, Thor wields one of the greatest weapons ever made, the enchanted hammer Mjolnir. While others have described Thor as an over-muscled, oafish imbecile, he\'s quite smart and compassionate.  He\'s self-assured, and he would never, ever stop fighting for a worthwhile cause.", modified: nil, resourceURI: nil, urls: nil, thumbnail: Image(path: "http://i.annihil.us/u/prod/marvel/i/mg/d/d0/5269657a74350", imgExtension: "jpg"), comics: nil, stories: nil, events: nil, series: nil)

    let threedman = Character(id: 1011334, name: "3-D Man", description: "", modified: nil, resourceURI: nil, urls: nil, thumbnail: Image(path: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", imgExtension: "jpg"), comics: nil, stories: nil, events: nil, series: nil)

    let abomb = Character(id: 1017100, name: "A-Bomb (HAS)", description: "Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction!", modified: nil, resourceURI: nil, urls: nil, thumbnail: Image(path: "http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16", imgExtension: "jpg"), comics: nil, stories: nil, events: nil, series: nil)

    let henrique = Character(id: 999, name: "Henrique", description: "SuperMentor", modified: nil, resourceURI: nil, urls: nil, thumbnail: nil, comics: nil, stories: nil, events: nil, series: nil)

    let thorModel = CharacterModel(id: 1009664, name: "Thor", description: "As the Norse God of thunder and lightning, Thor wields one of the greatest weapons ever made, the enchanted hammer Mjolnir. While others have described Thor as an over-muscled, oafish imbecile, he\'s quite smart and compassionate.  He\'s self-assured, and he would never, ever stop fighting for a worthwhile cause.", thumbnail: Image(path: "http://i.annihil.us/u/prod/marvel/i/mg/d/d0/5269657a74350", imgExtension: "jpg"))
    let threedmanModel = CharacterModel(id: 1011334, name: "3-D Man", description: "", thumbnail: Image(path: "http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16", imgExtension: "jpg"))
    let abombModel = CharacterModel(id: 1017100, name: "A-Bomb (HAS)", description: "Rick Jones has been Hulk's best bud since day one, but now he's more than a friend...he's a teammate! Transformed by a Gamma energy explosion, A-Bomb's thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction!", thumbnail: Image(path: "http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16", imgExtension: "jpg"))
    let henriqueModel = CharacterModel(id: 999, name: "Henrique", description: "SuperMentor", thumbnail: nil)
}
