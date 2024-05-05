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
    showMyProfileView()
  }
}

extension MyPageCoordinator {
  
  private func showMyProfileView() {
    
    let vm = MyProfileViewModel()
      .coordinator(self)
    
    let vc = MyProfileViewController(viewModel: vm)
      .hideBackTitle()
      .kcNavigationTitle(with: "마이 페이지")
    
    push(vc)
  }
  
  func showFollowListView(profile: BehaviorRelay<Profile>, followTab: FollowTabmanViewController.FollowTab) {
    
    let vm = FollowListViewModel(profile: profile)
      .coordinator(self)
    
    let vc = FollowTabmanViewController(viewModel: vm, followTab: followTab)
      .hideBackTitle()
      .hideTabBar()
      .navigationTitle(with: "팔로우")
    
    push(vc)
  }
}
