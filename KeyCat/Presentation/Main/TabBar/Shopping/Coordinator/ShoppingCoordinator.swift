//
//  ShoppingCoordinator.swift
//  KeyCat
//
//  Created by 원태영 on 4/27/24.
//

import UIKit

final class ShoppingCoordinator: SubCoordinator {
  
  weak var delegate: CoordinatorDelegate?
  weak var tabBarDelegate: TabBarDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    showShoppoingView()
  }
}

extension ShoppingCoordinator {
  
  func showShoppoingView() {
    let vm = ShoppingViewModel()
      .coordinator(self)
    let vc = ShoppingViewController(viewModel: vm)
      .kcNavigationTitle(with: MainTabBarPage.shopping.title)
    
    push(vc)
  }
}
