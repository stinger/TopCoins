//
//  Coordinator.swift
//  TopCoins
//
//  Created by Ilian Konchev on 19.02.25.
//

import UIKit

class Coordinator {

    weak var navigationController: UINavigationController?
    weak var parentCoordinator: Coordinator?
    var subCoordinator: Coordinator?

    var completion: () -> Void = {}

    init(navigationController: UINavigationController?, completion: (() -> Void)?) {
        self.navigationController = navigationController

        if let completion = completion {
            self.completion = completion
        }
    }

    convenience init(viewController: UIViewController, completion: (() -> Void)?) {
        self.init(navigationController: viewController.navigationController, completion: completion)
    }

    convenience init(parentCoordinator: Coordinator) {
        self.init(
            navigationController: parentCoordinator.navigationController, completion: parentCoordinator.completion)
        if parentCoordinator.subCoordinator != nil {
            parentCoordinator.subCoordinator = nil
        }
        parentCoordinator.subCoordinator = self
        self.parentCoordinator = parentCoordinator
    }

    func start() {

    }

    func start(subCoordinator: Coordinator) {
        self.subCoordinator = subCoordinator
        self.subCoordinator?.start()
    }

    func completeSubWorkflow() {
        self.subCoordinator = nil
    }

    func start(viewController: UIViewController) {

    }

    func present(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController?.present(viewController, animated: animated, completion: completion)
    }

    func push(viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
        finishWorkflow()
    }

    func finishWorkflow() {
        if let parentWorkflow = parentCoordinator {
            parentWorkflow.completeSubWorkflow()
        } else {
            completeSubWorkflow()
            completion()
        }
    }
}
