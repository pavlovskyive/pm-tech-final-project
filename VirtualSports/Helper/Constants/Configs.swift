//
//  Configs.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 24.03.2021.
//

import Foundation
import APILayer
import AuthLayer

let apiConfig = APIConfig(scheme: "https",
                          host: "virtual-sports-yi3j9.ondigitalocean.app",
                          mainPath: "/Games",
                          favouritesPath: "/User/favourites",
                          favouriteGamePath: "/User/favourite",
                          recentPath: "/User/recent",
                          playGamePath: "/Games/play",
                          gameHistoryPath: "/User/history")

let authConfig = AuthConfig(scheme: "https",
                            host: "virtual-sports-yi3j9.ondigitalocean.app",
                            loginPath: "/login",
                            registerPath: "/register",
                            logoutPath: "/logout")
