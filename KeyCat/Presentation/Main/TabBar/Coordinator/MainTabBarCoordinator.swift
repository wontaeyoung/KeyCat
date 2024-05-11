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

final class MainTabBarCoordinator: SubCoordinator {
  
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
    let rootNavigationControllers = MainTabBarPage.allCases.map { page in
      makeNavigationController(with: page)
    }
    
    configureTabBarController(with: rootNavigationControllers)
  }
  
  private func configureTabBarController(with controllers: [UINavigationController]) {
    tabBarController.configure {
      $0.setViewControllers(controllers, animated: false)
      $0.selectedIndex = MainTabBarPage.shopping.index
    }
  }
  
  private func makeNavigationController(with page: MainTabBarPage) -> UINavigationController {
    return UINavigationController().configured {
      $0.tabBarItem = page.tabBarItem
      connectTabFlow(page: page, tabPageController: $0)
    }
  }
  
  private func connectTabFlow(page: MainTabBarPage, tabPageController: UINavigationController) {
    switch page {
      case .home:
        let coordinator = HomeCoordinator(tabPageController)
        addChild(coordinator)
        coordinator.start()
        coordinator.tabBarDelegate = self
        coordinator.signOutDelegate = self
        
      case .shopping:
        let coordinator = ShoppingCoordinator(tabPageController)
        addChild(coordinator)
        coordinator.start()
        coordinator.tabBarDelegate = self
        coordinator.signOutDelegate = self
        
      case .profile:
        let coordinator = MyPageCoordinator(tabPageController)
        addChild(coordinator)
        coordinator.start()
        coordinator.tabBarDelegate = self
        coordinator.signOutDelegate = self
    }
  }
}

extension MainTabBarCoordinator: SignOutDelegate { }
