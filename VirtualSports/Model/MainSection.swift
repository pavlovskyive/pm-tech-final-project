//
//  MainSection.swift
//  VirtualSports
//
//  Created by Вова Благой on 26.03.2021.
//

import Foundation
import APILayer

struct GameSection: Hashable {
    let tag: String
    let title: String
    let items: [Game]
}

extension Game: Hashable {

    public func hash(into hasher: inout Hasher) {

    }

    public static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.id == rhs.id
    }

}
