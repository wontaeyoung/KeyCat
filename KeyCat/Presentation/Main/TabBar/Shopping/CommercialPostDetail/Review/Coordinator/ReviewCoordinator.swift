//
//  ReviewCoordinator.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import UIKit

final class ReviewCoordinator: SubCoordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    
  }
}

extension ReviewCoordinator {
  
}
