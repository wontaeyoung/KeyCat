//
//  ShoppingViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 4/27/24.
//

import RxSwift
import RxCocoa

final class ShoppingViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ShoppingCoordinator?
  
  // MARK: - Initializer
  init() {
    
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    return Output()
  }
}