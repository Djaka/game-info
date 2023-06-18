//
//  AboutModel.swift
//  PremierLeagueInfo
//
//  Created by Djaka Permana on 30/05/23.
//

import Foundation

struct ResponseData: Codable {
    var about: About?
    
    enum CodingKeys: String, CodingKey {
        case about = "data"
    }
}

struct About: Codable {
    var author: String?
    var email: String?
    var currentJob: String?
    var description: String?
    var authorImage: String?
    
    enum CodingKeys: String, CodingKey {
        case author = "author"
        case email = "email"
        case currentJob = "current_job"
        case description = "description"
        case authorImage = "author_image"
    }
}
