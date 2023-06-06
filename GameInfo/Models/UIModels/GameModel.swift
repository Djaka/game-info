//
//  GameModel.swift
//  GameInfo
//
//  Created by Djaka Permana on 04/06/23.
//

import UIKit

class GameModel {
    let id: Int?
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let parentPlatforms: [ParentPlatform]?
    
    var image: UIImage?
    var downloadState: DownloadState = .new
    var platformImages: [UIImageView]?
    
    init(
        id: Int?,
        name: String?,
        released: String?,
        backgroundImage: String?,
        rating: Double?,
        parentPlatforms: [ParentPlatform]?
    ) {
        self.id = id
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.parentPlatforms = parentPlatforms
    }
}
