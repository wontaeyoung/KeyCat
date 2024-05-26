//
//  ChatRoomListViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/26/24.
//

import RxSwift
import RxCocoa

final class ChatRoomListViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ChatCoordinator?
  
  // MARK: - Initializer
  init() {
    
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    return Output()
  }
}
