//
//  AuthCoordinator.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

import UIKit

final class AuthCoordinator: SubCoordinator {
  
  weak var delegate: CoordinatorDelegate?
  weak var signOutDelegate: SignOutDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  private lazy var signUpVM = SignUpViewModel()
    .coordinator(self)
  
  private lazy var stopSignUpBarItem = UIBarButtonItem(
    image: KCAsset.Symbol.leaveButton,
    style: .plain,
    target: self,
    action: #selector(showStopSignUpAlert)
  )
  
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
      .hideBackButton()
      .barItemAdded(at: .right, item: stopSignUpBarItem)
    
    push(vc)
  }
  
  func showSignUpBusinessInfoAuthenticationView() {
    
    let vc = SignUpBusinessInfoAuthenticationViewController(viewModel: signUpVM)
      .hideBackTitle()
      .barItemAdded(at: .right, item: stopSignUpBarItem)
    
    push(vc)
  }
  
  func showSignUpEmailView() {
    let vc = SignUpEmailViewController(viewModel: signUpVM)
      .hideBackTitle()
      .barItemAdded(at: .right, item: stopSignUpBarItem)
    
    push(vc)
  }
  
  func showSignUpPasswordView() {
    let vc = SignUpPasswordViewController(viewModel: signUpVM)
      .hideBackTitle()
      .barItemAdded(at: .right, item: stopSignUpBarItem)
    
    push(vc)
  }
  
  func showSignUpProfileView() {
    let vc = SignUpProfileViewController(viewModel: signUpVM)
      .hideBackTitle()
      .barItemAdded(at: .right, item: stopSignUpBarItem)
    
    push(vc)
  }
  
  func login() {
    end()
  }
  
  @objc private func showStopSignUpAlert() {
    
    showAlert(
      title: "회원가입 중단",
      message: "지금까지 작성하신 내용이 모두 사라져요.\n회원가입을 중단하고 로그인 화면으로 돌아갈까요?",
      okStyle: .destructive,
      isCancelable: true
    ) { [weak self] in
      guard let self else { return }
      
      end()
    }
  }
}
