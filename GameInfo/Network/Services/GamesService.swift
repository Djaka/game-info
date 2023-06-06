//
//  GameServiceNetwork.swift
//  GameInfo
//
//  Created by Djaka Permana on 03/06/23.
//

import Foundation

protocol GameServiceProvider {
    func getGames(page: Int, pageSize: Int, search: String) async -> Result<GameResponseModel, HTTPError>
    func getGamesDetail(with id: Int) async -> Result<GameDetailResponse, HTTPError>
}

public class GamesService: HTTPClient, GameServiceProvider {
    
    func getGames(page: Int, pageSize: Int, search: String = "") async -> Result<GameResponseModel, HTTPError> {
        return await request(
            endpoint: GamesEndpoint.games(page: page, pageSize: pageSize, search: search),
            responseModel: GameResponseModel.self
        )
    }
    
    func getGamesDetail(with id: Int) async -> Result<GameDetailResponse, HTTPError> {
        return await request(
            endpoint: GamesEndpoint.gamesDetail(id: id),
            responseModel: GameDetailResponse.self
        )
    }
    
}
