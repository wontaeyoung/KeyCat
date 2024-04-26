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
  
  private lazy var signUpVM = SignUpViewModel()
    .coordinator(self)
  
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
      .hideBackTitle()
    
    push(vc)
  }
  
  func showSignUpView() {
    let vc = SignUpSellerAuthorityViewController(viewModel: signUpVM)
      .hideBackTitle()
    
    push(vc)
  }
  
  func showSignUpBusinessInfoAuthenticationView() {
    let vc = SignUpBusinessInfoAuthenticationViewController(viewModel: signUpVM)
      .hideBackTitle()
    
    push(vc)
  }
  
  func showSignUpEmailView() {
    let vc = SignUpEmailViewController(viewModel: signUpVM)
      .hideBackTitle()
    
    push(vc)
  }
  
  func showSignUpPasswordView() {
    let vc = SignUpPasswordViewController(viewModel: signUpVM)
      .hideBackTitle()
    
    push(vc)
  }
  
  func showSignUpProfileView() {
    let vc = SignUpProfileViewController(viewModel: signUpVM)
      .hideBackTitle()
    
    push(vc)
  }
  
  func login() {
    end()
  }
}
