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
    showMyProfileView(userID: UserInfoService.userID, myProfile: nil)
  }
}

extension MyPageCoordinator {
  
  func showMyProfileView(userID: User.UserID, myProfile: BehaviorRelay<Profile>?) {
    
    let vm = ProfileViewModel(userID: userID, myProfile: myProfile)
      .coordinator(self)
    
    let vc = ProfileViewController(viewModel: vm)
      .hideBackTitle()
    
    if UserInfoService.isMyUserID(with: userID) {
      vc.setKCNavigationTitle(with: "마이 페이지")
    } else {
      vc.setTabBarHidden()
    }
    
    push(vc)
  }
  
  func showFollowListView(profile: BehaviorRelay<Profile>, myProfile: BehaviorRelay<Profile>, followTab: FollowTabmanViewController.FollowTab) {
    
    let vm = FollowListViewModel(profile: profile, myProfile: myProfile)
      .coordinator(self)
    
    let vc = FollowTabmanViewController(viewModel: vm, followTab: followTab)
      .hideBackTitle()
      .hideTabBar()
      .navigationTitle(with: "팔로우")
    
    push(vc)
  }
}
