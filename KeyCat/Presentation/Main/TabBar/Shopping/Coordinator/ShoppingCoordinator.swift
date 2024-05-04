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
  weak var tabBarDelegate: TabBarDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    showShoppoingView()
  }
}

extension ShoppingCoordinator {
  
  func showShoppoingView() {
    let vm = ShoppingViewModel()
      .coordinator(self)
    
    let vc = ShoppingViewController(viewModel: vm)
      .kcNavigationTitle(with: MainTabBarPage.shopping.title)
      .hideBackTitle()
    
    push(vc)
  }
  
  func showCreatePostView() {
    let vm = CreateCommercialPostViewModel()
      .coordinator(self)
    
    let vc = CreateCommercialPostViewController(viewModel: vm)
      .hideBackButton()
      .hideTabBar()
      .navigationTitle(with: "상품 판매", displayMode: .never)
    
    push(vc)
  }
  
  func showPostDetailView(post: CommercialPost, from originalPosts: BehaviorRelay<[CommercialPost]>) {
    let vm = CommercialPostDetailViewModel(post: post, originalPosts: originalPosts)
      .coordinator(self)
    
    let vc = CommercialPostDetailViewController(viewModel: vm)
      .hideBackTitle()
      .hideTabBar()
      .navigationTitle(with: "상품 상세", displayMode: .never)
    
    push(vc)
  }
  
  func ConnectReviewFlow() {
    let coordinator = ReviewCoordinator(navigationController)
    coordinator.delegate = self
    coordinator.start()
    addChild(coordinator)
  }
}

extension ShoppingCoordinator: CoordinatorDelegate {
  
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    emptyOut()
  }
}
