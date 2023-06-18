//
//  GameService.swift
//  GameInfo
//
//  Created by Djaka Permana on 03/06/23.
//

import Foundation

enum GamesEndpoint {
    case games(page: Int, pageSize: Int, search: String)
    case gamesDetail(id: Int)
}

extension GamesEndpoint: Endpoint {
    
    var baseURL: URL {
        if let validURL = URL(string: APIConstants.baseURL) {
            return validURL
        } else {
            return NSURL() as URL
        }
    }
    
    var path: String {
        switch self {
        case .games:
            return "/games"
        case .gamesDetail(let id):
            return "/games/\(id)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var defaultParameter = getDefaultparameter()
        switch self {
        case .games(let page, let pageSize, let search):
            let parameter: [String: Any] = [
                "page": page,
                "page_size": pageSize,
                "search": search
            ]
            defaultParameter.merge(parameter) { (_, new: Any) -> Any in
                return new
            }
            return defaultParameter
        default:
            return defaultParameter
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return .urlEncoding
        }
    }
    
}
