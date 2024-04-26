//
//  AppCoordinator.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

import UIKit

final class AppCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  weak var window: UIWindow?
  var childCoordinators: [Coordinator] = []
  
  init(window: UIWindow?) {
    self.window = window
  }
  
  func start() {
    connectFlow()
  }
}

extension AppCoordinator {
  
  private func connectSignFlow() {
    let rootNavigationVC = UINavigationController()
    let authCoordinator = AuthCoordinator(rootNavigationVC)
    authCoordinator.delegate = self
    authCoordinator.start()
    self.addChild(authCoordinator)
    
    window?.rootViewController = rootNavigationVC
    window?.makeKeyAndVisible()
  }
  
  private func connectMainTabBarFlow() {
    
  }
}

extension AppCoordinator: CoordinatorDelegate {
  
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    connectFlow()
  }
  
  private func connectFlow() {
    if APITokenContainer.hasSignInLog {
      connectMainTabBarFlow()
    } else {
      connectSignFlow()
    }
  }
}
