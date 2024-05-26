//
//  ChatCoordinator.swift
//  KeyCat
//
//  Created by 원태영 on 5/26/24.
//

import UIKit

final class ChatCoordinator: SubCoordinator {
  
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
    
  }
}

extension ChatCoordinator: SignOutDelegate { }
