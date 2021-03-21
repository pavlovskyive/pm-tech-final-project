//
//  ApplicationCoordinator.swift
//  VirtualSports
//
//  Created by Вова Благой on 21.03.2021.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {

    // MARK: - Vars & Lets
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private let router: RouterProtocol

    // MARK: - Coordinator
    override func start() {

        runMainFlow()
    }

    // MARK: - Private methods
    private func runMainFlow() {

        let coordinator = self.coordinatorFactory.makeMainCoordinatorBox(router: self.router,
                                                                         coordinatorFactory: CoordinatorFactory())
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeDependency(coordinator)
            self.start()
        }
        self.addDependency(coordinator)
        coordinator.start()
    }

    // MARK: - Init
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }

}
