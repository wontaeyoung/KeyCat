//
//  MainTabBarCoordinator.swift
//  KeyCat
//
//  Created by 원태영 on 4/27/24.
//

import UIKit

protocol TabBarDelegate: AnyObject {
  func moveTab(to tab: MainTabBarPage)
}

extension MainTabBarCoordinator: TabBarDelegate {
  func moveTab(to tab: MainTabBarPage) {
    tabBarController.selectedIndex = tab.index
  }
}

final class MainTabBarCoordinator: Coordinator {
  
  // MARK: - Property
  var navigationController: UINavigationController
  weak var delegate: CoordinatorDelegate?
  weak var signOutDelegate: SignOutDelegate?
  var childCoordinators: [Coordinator]
  var tabBarController: UITabBarController
  
  init(_ navigationController: UINavigationController, tabBarController: UITabBarController) {
    self.navigationController = navigationController
    self.childCoordinators = []
    self.tabBarController = tabBarController
  }
  
  // MARK: - Method
  func start() {
    let rootNavigationControllers = MainTabBarPage.allCases.map { makeNavigationController(with: $0) }
    configureTabBarController(with: rootNavigationControllers)
  }
  
  private func configureTabBarController(with controllers: [UINavigationController]) {
    tabBarController.configure {
      $0.setViewControllers(controllers, animated: false)
      $0.selectedIndex = MainTabBarPage.home.index
    }
  }
  
  private func makeNavigationController(with page: MainTabBarPage) -> UINavigationController {
    return UINavigationController().configured { connectTabFlow(page: page, tabPageController: $0) }
  }
  
  private func connectTabFlow(page: MainTabBarPage, tabPageController: UINavigationController) {
    tabPageController.tabBarItem = page.tabBarItem
    let coordinator = makeCoordinator(page: page, tabPageController: tabPageController)
    connectCoordinator(coordinator)
  }
  
  private func makeCoordinator(page: MainTabBarPage, tabPageController: UINavigationController) -> any SubCoordinator {
    switch page {
      case .home:
        return HomeCoordinator(tabPageController)
        
      case .shopping:
        return ShoppingCoordinator(tabPageController)
        
      case .chat:
        return ChatCoordinator(tabPageController)
        
      case .profile:
        return MyPageCoordinator(tabPageController)
    }
  }
  
  private func connectCoordinator(_ coordinator: any SubCoordinator) {
    addChild(coordinator)
    coordinator.start()
    coordinator.tabBarDelegate = self
    coordinator.signOutDelegate = self
  }
}

extension MainTabBarCoordinator: SignOutDelegate { }
