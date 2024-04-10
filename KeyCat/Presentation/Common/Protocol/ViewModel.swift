//
//  ViewModel.swift
//  KazStore
//
//  Created by 원태영 on 4/5/24.
//

import RxSwift

protocol ViewModel: AnyObject {
  
  associatedtype Input
  associatedtype Output
  associatedtype CoordinatorType: Coordinator
  
  // MARK: - Property
  var disposeBag: DisposeBag { get }
  var coordinator: CoordinatorType? { get set }
  
  // MARK: - Method
  func transform(input: Input) -> Output
}

extension ViewModel {
  func coordinator(_ coordinator: CoordinatorType) -> Self {
    self.coordinator = coordinator
    
    return self
  }
}
