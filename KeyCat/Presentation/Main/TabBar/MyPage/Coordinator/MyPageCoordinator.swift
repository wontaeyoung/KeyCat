//
//  MyPageCoordinator.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import UIKit
import RxRelay

final class MyPageCoordinator: SubCoordinator {
  
  weak var delegate: CoordinatorDelegate?
  weak var tabBarDelegate: TabBarDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    
  }
}

extension MyPageCoordinator {
  
}
