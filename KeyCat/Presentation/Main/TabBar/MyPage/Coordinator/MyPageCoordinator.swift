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
  weak var signOutDelegate: SignOutDelegate?
  weak var tabBarDelegate: TabBarDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    showMyProfileView(userID: UserInfoService.userID)
  }
}

extension MyPageCoordinator {
  
  func showMyProfileView(userID: User.UserID) {
    
    let vm = ProfileViewModel(
      fetchProfileUsecase: DIContainer.fetchProfileUsecase,
      userInteractionUsecase: DIContainer.userInteractionUsecase,
      signUsecase: DIContainer.signUsecase,
      userID: userID
    )
      .coordinator(self)
    
    let vc = ProfileViewController(viewModel: vm)
      .hideBackTitle()
      .navigationTitle(with: UserInfoService.isMyUserID(with: userID) ? "마이 페이지" : "다른 사람의 프로필")
    
    if !UserInfoService.isMyUserID(with: userID) {
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
  
  func showPostListView(userID: CommercialPost.UserID, postCase: PostListViewModel.PostCase) {
    
    let vm = PostListViewModel(
      fetchCommercialPostUsecase: DIContainer.fetchCommercialPostUsecase,
      userID: userID,
      postCase: postCase
    )
      .coordinator(self)
    
    let vc = PostListViewController(viewModel: vm)
      .hideBackTitle()
      .hideTabBar()
      .navigationTitle(with: postCase.title)
    
    push(vc)
  }
  
  func connectUpdateProfileFlow(profile: Profile) {
    
    let coordinator = AuthCoordinator(navigationController)
    coordinator.showSignUpProfileView(writingProfileCase: .update(profile: profile))
    addChild(coordinator)
  }
}

extension MyPageCoordinator: SignOutDelegate { }
