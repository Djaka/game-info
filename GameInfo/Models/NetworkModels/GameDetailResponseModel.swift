//
//  GameDetailResponseModel.swift
//  GameInfo
//
//  Created by Djaka Permana on 05/06/23.
//

import Foundation

// MARK: - GameDetailResponse
struct GameDetailResponse: Codable {
    let id: Int?
    let slug, name, nameOriginal, description: String?
    let released: String?
    let updated: String?
    let backgroundImage, backgroundImageAdditional: String?
    let website: String?
    let rating: Double?
    let alternativeNames: [String]?
    let reviewsCount: Int?
    let parentPlatforms: [ParentPlatform]?
    let descriptionRaw: String?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, name
        case nameOriginal = "name_original"
        case description
        case released, updated
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case website, rating
        case alternativeNames = "alternative_names"
        case reviewsCount = "reviews_count"
        case parentPlatforms = "parent_platforms"
        case descriptionRaw = "description_raw"
    }
}
