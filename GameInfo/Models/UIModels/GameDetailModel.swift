//
//  GameDetailModel.swift
//  GameInfo
//
//  Created by Djaka Permana on 06/06/23.
//

import UIKit

class GameDetailModel {
    let id: Int?
    let name: String?
    let released: String?
    let backgroundImage: String?
    let backgroundImageAdditional: String?
    let rating: Double?
    let parentPlatforms: [ParentPlatform]?
    let description: String?
    
    var image: UIImage?
    var additionalImage: UIImage?
    var imageState: DownloadState = .new
    var imageAdditionalState: DownloadState = .new
    var platformImages: [UIImageView]?
    
    init(
        id: Int?,
        name: String?,
        released: String?,
        backgroundImage: String?,
        backgroundImageAdditional: String?,
        rating: Double?,
        parentPlatforms: [ParentPlatform]?,
        description: String?
    ) {
        self.id = id
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.backgroundImageAdditional = backgroundImageAdditional
        self.rating = rating
        self.parentPlatforms = parentPlatforms
        self.description = description
    }
}
