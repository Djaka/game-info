//
//  Service.swift
//  GameInfo
//
//  Created by Djaka Permana on 03/06/23.
//

import Foundation

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var httpMethod: HTTPMethod { get }
    var parameterEncoding: ParameterEncoding { get }
}

extension Endpoint {
    func getDefaultparameter(authenticated: Bool = true) -> [String: Any] {
        var httpHeader: [String: String] = [:]
        
        if authenticated {
            httpHeader["key"] = APIConstants.key
        }
        
        return httpHeader
    }
}
