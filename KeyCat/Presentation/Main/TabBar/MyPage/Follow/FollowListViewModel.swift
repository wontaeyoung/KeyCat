//
//  FollowListViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift
import RxCocoa

final class FollowListViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: MyPageCoordinator?
  
  // MARK: - Initializer
  init() {
    
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
   
    return Output()
  }
}
