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
    let rootTabBarController = UITabBarController()
    let mainTabBarCoordinator = MainTabBarCoordinator(tabBarController: rootTabBarController)
    mainTabBarCoordinator.delegate = self
    mainTabBarCoordinator.start()
    addChild(mainTabBarCoordinator)
    
    window?.rootViewController = rootTabBarController
    window?.makeKeyAndVisible()
    
    updateKingfisherHeader()
  }
  
  private func updateKingfisherHeader() {
    KingfisherManager.shared.downloader.sessionConfiguration = URLSessionConfiguration.default.applied {
      $0.httpAdditionalHeaders = [
        KCHeader.Key.sesacKey: APIKey.sesacKey,
        KCHeader.Key.authorization: UserInfoService.accessToken
      ]
      
      $0.timeoutIntervalForRequest = 30
    }
  }
}

extension AppCoordinator: CoordinatorDelegate {
  
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    connectFlow()
  }
  
  private func connectFlow() {
    if UserInfoService.hasSignInLog {
      connectMainTabBarFlow()
    } else {
      connectSignFlow()
    }
  }
}
