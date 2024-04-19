//
//  SignUpViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: AuthCoordinator?
  
  // MARK: - Initializer
  init() {
    
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    return Output()
  }
}

