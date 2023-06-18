//
//  HTTPClient.swift
//  GameInfo
//
//  Created by Djaka Permana on 03/06/23.
//

import Foundation

protocol HTTPClient {
    func request<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, HTTPError>
}

extension HTTPClient {
    func request<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, HTTPError> {
        var components = URLComponents(string: endpoint.baseURL.absoluteString)
        components?.path = endpoint.baseURL.path + endpoint.path
        components?.queryItems = getQueryItems(with: endpoint)
        
        guard let componentUrl = components?.url else {
            return .failure(.invalidUrl)
        }
        
        let urlRequest = getUrlRequest(with: componentUrl, endpoint: endpoint)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unAuthorize)
            default:
                return .failure(.unknown)
            }
            
        } catch {
            return .failure(.unknown)
        }
    }
    
    private func getQueryItems(with endpoint: Endpoint) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        if case ParameterEncoding.urlEncoding = endpoint.parameterEncoding {
            
            guard let params = endpoint.parameters else {
                return []
            }
            
            for (paramKey, paramValue) in params {
                queryItems.append(URLQueryItem(name: paramKey, value: toString(paramValue)))
            }
            
            return queryItems
        }
        
        return queryItems
    }
    
    private func toString(_ value: Any?) -> String {
        return String(describing: value ?? "")
    }
    
    private func getUrlRequest(with componentUrl: URL, endpoint: Endpoint) -> URLRequest {
        var urlRequest = URLRequest(url: componentUrl)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        
        if case ParameterEncoding.jsonEncoding = endpoint.parameterEncoding {

            guard let params = endpoint.parameters else {
                return urlRequest
            }

            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        return urlRequest
    }
}
