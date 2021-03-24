//
//  Configs.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 24.03.2021.
//

import Foundation
import APIService
import AuthService

let apiConfig = APIConfig(scheme: "https",
                          host: "virtual-sports-yi3j9.ondigitalocean.app",
                          mainPath: "/Games")

let authConfig = AuthConfig(scheme: "https",
                            host: "virtual-sports-yi3j9.ondigitalocean.app",
                            loginPath: "/login",
                            registerPath: "/register",
                            logoutPath: "/logout")
