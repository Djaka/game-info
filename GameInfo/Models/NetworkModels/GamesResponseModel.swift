//
//  GamesModel.swift
//  GameInfo
//
//  Created by Djaka Permana on 03/06/23.
//

import UIKit

// MARK: - GameResponse
struct GameResponseModel: Codable {
    let results: [Game]?
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

// MARK: - Result
struct Game: Codable {
    let id: Int?
    let slug: String?
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let updated: String?
    let parentPlatforms: [ParentPlatform]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case slug = "slug"
        case name = "name"
        case released = "released"
        case backgroundImage = "background_image"
        case rating = "rating"
        case updated = "updated"
        case parentPlatforms = "parent_platforms"
    }
}
