//
//  AboutModel.swift
//  PremierLeagueInfo
//
//  Created by Djaka Permana on 30/05/23.
//

import Foundation

struct ResponseData: Codable {
    var about: About? = nil
    
    enum CodingKeys: String, CodingKey {
        case about = "data"
    }
}

struct About: Codable {
    var author: String? = nil
    var currentJob: String? = nil
    var description: String? = nil
    var authorImage: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case author = "author"
        case currentJob = "current_job"
        case description = "description"
        case authorImage = "author_image"
    }
}
