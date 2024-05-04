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
  
  func showReviewListView(post: CommercialPost) {
    
    let vm = ReviewListViewModel(post: post)
      .coordinator(self)
    
    let vc = ReviewListViewController(viewModel: vm)
      .hideBackTitle()
      .navigationTitle(with: "리뷰 모아보기", displayMode: .never)
    
    push(vc)
  }
  
  func showCreateCommercialReviewView(post: CommercialPost) {
    
    let vm = CreateCommercialReviewViewModel(post: post)
      .coordinator(self)
    
    let vc = CreateCommercialReviewViewController(viewModel: vm)
      .hideBackTitle()
      .navigationTitle(with: "리뷰 쓰기", displayMode: .never)
    
    push(vc)
  }
}
