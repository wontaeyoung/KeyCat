//
//  HomeCoordinator.swift
//  KeyCat
//
//  Created by 원태영 on 5/10/24.
//

import UIKit
import RxRelay

final class HomeCoordinator: SubCoordinator {
  
  weak var delegate: CoordinatorDelegate?
  weak var signOutDelegate: SignOutDelegate?
  weak var tabBarDelegate: TabBarDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    showHomeView()
  }
}

extension HomeCoordinator {
  
  func showHomeView() {
    
    let vc = HomeViewController()
      .hideBackTitle()
      .kcNavigationTitle(with: "홈")
    
    push(vc)
  }
}

extension HomeCoordinator: CoordinatorDelegate {
  
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    
    emptyOut()
  }
}

extension HomeCoordinator: SignOutDelegate { }

