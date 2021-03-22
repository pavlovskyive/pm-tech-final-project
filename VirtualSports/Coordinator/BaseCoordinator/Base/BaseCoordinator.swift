//
//  BaseCoordinator.swift
//  VirtualSports
//
//  Created by Вова Благой on 21.03.2021.
//

import Foundation

class BaseCoordinator: Coordinator {

    // MARK: - Vars & Lets
    var childCoordinators = [Coordinator]()

    // MARK: - Public methods
    func addDependency(_ coordinator: Coordinator) {

        for element in childCoordinators where element === coordinator {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: Coordinator?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }

        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }

    // MARK: - Coordinator
    func start() {
    }

}
