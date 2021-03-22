//
//  APIServiceMock.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 20.03.2021.
//

import Foundation
import APIService
import NetworkService

/*
 USAGE:
 
 let api = APIServiceMock()

 api.fetchMain { result in
     switch result {
     case .success(let main):
         print(main)
     case .failure(let error):
         print("\(error)")
     }
 }

 api.fetchGame(with: "gameId") { result in
     switch result {
     case .success(let game):
         print(game)
     case .failure(let error):
         print("\(error)")
     }
 }
 
 */

public final class APIServiceMock: APIProvider {

    public var networkService: NetworkProvider

    public var config: APIConfig

    init() {
        config = APIConfig(scheme: "https",
                           host: "mock.com",
                           mainPath: "/main",
                           gamePath: "/game")
        networkService = NetworkService()
    }

}

extension APIServiceMock {

    public func fetchMain(completion: @escaping MainCompletion) {
        guard let path = Bundle.main.path(forResource: "main", ofType: "json") else {
            completion(.failure(.couldNotParseURL))
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let main = try JSONDecoder().decode(MainResponse.self, from: data)
            completion(.success(main))
        } catch {
            completion(.failure(.networkError(.badData)))
        }
    }

    public func fetchGame(with: String, completion: @escaping GameCompletion) {
        guard let path = Bundle.main.path(forResource: "game", ofType: "json") else {
            completion(.failure(.couldNotParseURL))
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let game = try JSONDecoder().decode(GameConfig.self, from: data)
            completion(.success(game))
        } catch {
            completion(.failure(.networkError(.badData)))
        }
    }

}
