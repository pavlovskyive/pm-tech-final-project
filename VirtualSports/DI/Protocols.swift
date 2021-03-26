//
//  Protocols.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 25.03.2021.
//

import Foundation
import AuthLayer
import APILayer

protocol HasAuthProvider {
    var authProvider: AuthProvider { get }
}

protocol HasAPIFetching {
    var apiService: APIFetchable { get }
}
