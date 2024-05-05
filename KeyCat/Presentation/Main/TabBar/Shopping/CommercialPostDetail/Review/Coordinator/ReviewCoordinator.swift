//
//  ReviewCoordinator.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import UIKit
import RxRelay

final class ReviewCoordinator: SubCoordinator {
  
  weak var delegate: CoordinatorDelegate?
  weak var signOutDelegate: SignOutDelegate?
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
  
  func showReviewListView(post: BehaviorRelay<CommercialPost>) {
    
    let vm = ReviewListViewModel(post: post)
      .coordinator(self)
    
    let vc = ReviewListViewController(viewModel: vm)
      .hideBackTitle()
      .navigationTitle(with: "리뷰 모아보기", displayMode: .never)
    
    push(vc)
  }
  
  func showCreateCommercialReviewView(post: CommercialPost, reviews: BehaviorRelay<[CommercialReview]>) {
    
    let vm = CreateCommercialReviewViewModel(post: post, reviews: reviews)
      .coordinator(self)
    
    let vc = CreateCommercialReviewViewController(viewModel: vm)
      .hideBackTitle()
      .navigationTitle(with: "리뷰 쓰기", displayMode: .never)
    
    push(vc)
  }
  
  func showCommercialReviewDetailView(
    postID: CommercialPost.PostID,
    review: CommercialReview,
    reviews: BehaviorRelay<[CommercialReview]>
  ) {
    
    let vm = CommercialReviewDetailViewModel(postID: postID, review: review, reviews: reviews)
      .coordinator(self)
    
    let vc = CommercialReviewDetailViewController(viewModel: vm)
      .hideBackTitle()
      .navigationTitle(with: "리뷰 상세", displayMode: .never)
    
    push(vc)
  }
}

extension ReviewCoordinator: SignOutDelegate { }
