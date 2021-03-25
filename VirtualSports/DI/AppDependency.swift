//
//  AppDependencies.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 25.03.2021.
//

import Foundation
import APIService
import AuthService
import NetworkService
import KeychainWrapper

struct AppDependency: HasAuthenticator, HasAPIFetching {

    var authProvider: Authenticator
    var apiService: APIFetchable

    public init() {

        let networkProvider = NetworkService()

        let authProvider = AuthProvider(networkProvider: networkProvider,
                                        secureStorage: KeychainWrapper(),
                                        config: authConfig)

        let apiService = APIService(networkProvider: networkProvider,
                                    config: apiConfig)

        self.authProvider = authProvider
        self.apiService = apiService
    }
}
