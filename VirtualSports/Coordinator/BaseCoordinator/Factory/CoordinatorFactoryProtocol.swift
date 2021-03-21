//
//  CoordinatorFactoryProtocol.swift
//  VirtualSports
//
//  Created by Вова Благой on 21.03.2021.
//

import Foundation

protocol CoordinatorFactoryProtocol {

    func makeMainCoordinatorBox(router: RouterProtocol,
                                coordinatorFactory: CoordinatorFactoryProtocol) -> MainCoordinator
}

final class CoordinatorFactory: CoordinatorFactoryProtocol {

    // MARK: - CoordinatorFactoryProtocol
    func makeMainCoordinatorBox(router: RouterProtocol,
                                coordinatorFactory: CoordinatorFactoryProtocol) -> MainCoordinator {
        let coordinator = MainCoordinator(router: router, coordinatorFactory: coordinatorFactory)
        return coordinator
    }

}
