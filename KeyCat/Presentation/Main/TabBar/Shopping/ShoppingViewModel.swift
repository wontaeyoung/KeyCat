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
    let viewDidLoadEvent: PublishRelay<Void>
    
    init(
      viewDidLoadEvent: PublishRelay<Void> = .init()
    ) {
      self.viewDidLoadEvent = viewDidLoadEvent
    }
  }
  
  struct Output {
    let hasSellerAuthority: Driver<Bool>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ShoppingCoordinator?
  
  // MARK: - Initializer
  init() {
    
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let hasSellerAuthority = PublishRelay<Bool>()
    
    input.viewDidLoadEvent
      .map { UserInfoService.hasSellerAuthority }
      .bind(to: hasSellerAuthority)
      .disposed(by: disposeBag)
    
    return Output(hasSellerAuthority: hasSellerAuthority.asDriver(onErrorJustReturn: false))
  }
}
