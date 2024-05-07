//
//  CartPostListViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/7/24.
//

import RxSwift
import RxCocoa

final class CartPostListViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ShoppingCoordinator?
  private let cartPosts: BehaviorRelay<[CommercialPost]>
  
  // MARK: - Initializer
  init(cartPosts: BehaviorRelay<[CommercialPost]>) {
    self.cartPosts = cartPosts
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    return Output()
  }
}
