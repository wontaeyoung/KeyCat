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
  weak var delegate: CoordinatorDelegate?
  var childCoordinators: [Coordinator]
  var tabBarController: UITabBarController
  
  init(tabBarController: UITabBarController) {
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
      case .shopping:
        let coordinator = ShoppingCoordinator(tabPageController)
        addChild(coordinator)
        coordinator.start()
        coordinator.tabBarDelegate = self
        
      case .profile:
        break
    }
  }
}
