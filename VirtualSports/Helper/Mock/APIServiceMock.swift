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

public final class APIServiceMock: APIFetcher {

    public var networkService: NetworkProvider

    public var config: APIConfig

    init() {
        config = APIConfig(scheme: "https",
                           host: "mock.com",
                           mainPath: "/main")
        networkService = NetworkService()
    }

}

extension APIServiceMock {

    public func fetchMain(completion: @escaping MainCompletion) {
        guard let path = Bundle.main.path(forResource: "main", ofType: "json") else {
            completion(.failure(.internalError))
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

}
