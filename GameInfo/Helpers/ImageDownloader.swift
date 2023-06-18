//
//  ImageDownloader.swift
//  GameInfo
//
//  Created by Djaka Permana on 04/06/23.
//

import UIKit

enum DownloadState: Codable {
    case new, downloaded, failed
}

class ImageDownloader {
    func downloadImage(url: URL) async throws -> UIImage {
        async let imageData = try Data(contentsOf: url)
        return UIImage(data: try await imageData)!
    }
}
