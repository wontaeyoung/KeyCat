//
//  CreateCommercialReviewViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import RxSwift
import RxCocoa

final class CreateCommercialReviewViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ReviewCoordinator?
  
  // MARK: - Initializer
  init() {
    
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    return Output()
  }
}

