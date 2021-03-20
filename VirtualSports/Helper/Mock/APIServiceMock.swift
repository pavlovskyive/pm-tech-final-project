//
//  APIServiceMock.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 20.03.2021.
//

import Foundation
import APIService
import NetworkService

public final class APIServiceMock: APIProvider {

    public var networkService: NetworkProvider
    
    public var config: APIConfig
    
    init() {
        config = APIConfig(scheme: "https",
                           host: "mock.com",
                           mainPath: "/main",
                           gamePath: "/game")
        networkService = networkService()
    }
    
}
