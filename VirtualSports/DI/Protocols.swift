//
//  Protocols.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 25.03.2021.
//

import Foundation
import AuthService
import APIService

protocol HasAuthProvider {
    var authProvider: AuthProvider { get }
}

protocol HasAPIFetching {
    var apiService: APIFetchable { get }
}
