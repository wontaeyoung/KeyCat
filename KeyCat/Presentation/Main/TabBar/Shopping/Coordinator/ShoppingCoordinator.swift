//
//  ShoppingCoordinator.swift
//  KeyCat
//
//  Created by 원태영 on 4/27/24.
//

import UIKit
import RxRelay

final class ShoppingCoordinator: SubCoordinator {
  
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
    showShoppingView()
  }
}

extension ShoppingCoordinator {
  
  func showShoppingView() {
    
    let vm = ShoppingViewModel()
      .coordinator(self)
    
    let vc = ShoppingViewController(viewModel: vm)
      .kcNavigationTitle(with: MainTabBarPage.shopping.title)
      .hideBackTitle()
    
    push(vc)
  }
  
  func showCreatePostView(posts: BehaviorRelay<[CommercialPost]>) {
    
    let vm = CreateCommercialPostViewModel(posts: posts)
      .coordinator(self)
    
    let vc = CreateCommercialPostViewController(viewModel: vm)
      .hideBackButton()
      .hideTabBar()
      .navigationTitle(with: "상품 판매")
    
    push(vc)
  }
  
  func showCartPostListView(posts: BehaviorRelay<[CommercialPost]>, cartPosts: BehaviorRelay<[CommercialPost]>) {
    
    let vm = CartPostListViewModel(posts: posts, cartPosts: cartPosts)
      .coordinator(self)
    
    let vc = CartPostListViewController(viewModel: vm)
      .hideTabBar()
      .navigationTitle(with: "장바구니")
    
    push(vc)
  }
  
  func showPostDetailView(
    post: CommercialPost,
    originalPosts: BehaviorRelay<[CommercialPost]>,
    cartPosts: BehaviorRelay<[CommercialPost]>
  ) {
    
    let vm = CommercialPostDetailViewModel(post: post, originalPosts: originalPosts, cartPosts: cartPosts)
      .coordinator(self)
    
    let vc = CommercialPostDetailViewController(viewModel: vm)
      .hideBackTitle()
      .hideTabBar()
      .navigationTitle(with: "상품 상세")
    
    push(vc)
  }
  
  func showPaymentView(post: CommercialPost, paidSuccessTrigger: PublishRelay<Void>) {
    
    let vm = PaymentViewModel(post: post, paidSuccessTrigger: paidSuccessTrigger)
      .coordinator(self)
    
    let vc = PaymentViewController(viewModel: vm)
      .hideBackTitle()
      .navigationTitle(with: "결제하기")
    
    push(vc)
  }
  
  func presentCartPostListSheet(
    cartPosts: BehaviorRelay<[CommercialPost]>,
    viewModel: CommercialPostDetailViewModel
  ) {
    
    let vc = CartPostListSheetViewController(cartPosts: cartPosts, viewModel: viewModel)
    vc.sheetPresentationController?.configure {
      $0.detents = [.medium()]
      $0.prefersGrabberVisible = true
    }
    
    present(vc)
  }
  
  func connectReviewFlow(post: BehaviorRelay<CommercialPost>) {
    
    let coordinator = ReviewCoordinator(navigationController)
    coordinator.delegate = self
    coordinator.signOutDelegate = self
    coordinator.showReviewListView(post: post)
    addChild(coordinator)
  }
  
  func connectProfileFlow(user: User) {
    
    let coordinator = MyPageCoordinator(navigationController)
    coordinator.delegate = self
    coordinator.signOutDelegate = self
    coordinator.showMyProfileView(userID: user.userID)
    addChild(coordinator)
  }
}

extension ShoppingCoordinator: CoordinatorDelegate {
  
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    
    emptyOut()
  }
}

extension ShoppingCoordinator: SignOutDelegate { }
