//
//  HTTPError.swift
//  GameInfo
//
//  Created by Djaka Permana on 03/06/23.
//

import Foundation

enum HTTPError: Error {
    case decode
    case unAuthorize
    case invalidUrl
    case noResponse
    case unknown
    
    var message: String {
        switch self {
        case .decode:
            return "Error parsing data"
        case .unAuthorize:
            return "Unauthorize access"
        case .invalidUrl:
            return "Invalid URL"
        case .noResponse:
            return "No response"
        default:
            return "Something went wrong"
        }
    }
}
