//
//  AuthCoordinator.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

import UIKit

final class AuthCoordinator: SubCoordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    showSignInView()
  }
}

extension AuthCoordinator {
  
  func showSignInView() {
    let vm = SignInViewModel()
      .coordinator(self)
    
    let vc = SignInViewController(viewModel: vm)
    
    push(vc)
  }
  
  func showSignUpView() {
    let vm = SignUpViewModel()
      .coordinator(self)
    
    let vc = SignUpEmailViewController(viewModel: vm)
      .navigationTitle(with: "이메일을 입력해주세요", displayMode: .always)
      .hideBackTitle()
    
    push(vc)
  }
}
