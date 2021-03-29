//
//  AppDependencies.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 25.03.2021.
//

import Foundation
import APILayer
import AuthLayer
import NetworkService
import KeychainWrapper
import ImageLoader

struct AppDependency: HasAuthProvider, HasAPIFetching, HasImageLoader {

    var imageLoader: ImageLoader
    var authProvider: AuthProvider
    var apiService: APIFetchable

    public init() {

        let networkProvider = NetworkService()

        let authProvider = AuthProvider(networkProvider: networkProvider,
                                        secureStorage: KeychainWrapper(),
                                        config: authConfig)

        let apiService = APIService(networkProvider: networkProvider,
                                    config: apiConfig)
        let imageLoader = ImageLoader(networkProvider: NetworkService())

        self.authProvider = authProvider
        self.apiService = apiService
        self.imageLoader = imageLoader
    }
}
