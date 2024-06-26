//
//  AppCoordinator.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

import UIKit
import Kingfisher

final class AppCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  weak var signOutDelegate: SignOutDelegate?
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
  
  private func connectTestView() {
    let vc = ViewController()
    window?.rootViewController = vc
    window?.makeKeyAndVisible()
  }
  
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
    let rootTabBarController = UITabBarController()
    let mainTabBarCoordinator = MainTabBarCoordinator(.init(), tabBarController: rootTabBarController)
    mainTabBarCoordinator.delegate = self
    mainTabBarCoordinator.signOutDelegate = self
    mainTabBarCoordinator.start()
    addChild(mainTabBarCoordinator)
    
    window?.rootViewController = rootTabBarController
    window?.makeKeyAndVisible()
  }
}

extension AppCoordinator: CoordinatorDelegate {
  
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    connectFlow()
  }
}

extension AppCoordinator: SignOutDelegate {
  
  func signOut(_ childCoordinator: Coordinator?) {
    UserInfoService.logout()
    connectFlow()
  }
  
  private func connectFlow() {
    if UserInfoService.hasSignInLog {
      connectMainTabBarFlow()
      UserInfoService.updateKingfisherHeader()
    } else {
      connectSignFlow()
    }
  }
}
