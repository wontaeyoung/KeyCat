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
    let viewDidLoadEvent: PublishRelay<Void>
    
    init(
      viewDidLoadEvent: PublishRelay<Void> = .init()
    ) {
      self.viewDidLoadEvent = viewDidLoadEvent
    }
  }
  
  struct Output {
    let chatRooms: Driver<[ChatRoom]>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ChatCoordinator?
  private let chatRoomUsecase: any ChatRoomUsecase
  
  // MARK: - Initializer
  init(chatRoomUsecase: any ChatRoomUsecase) {
    self.chatRoomUsecase = chatRoomUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let chatRooms = BehaviorRelay<[ChatRoom]>(value: [])
    
    /// 뷰 로드 > 채팅방 리스트 요청
    input.viewDidLoadEvent
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.chatRoomUsecase.fetchMyChatRooms()
          .catch {
            owner.coordinator?.showErrorAlert(error: $0)
            return .never()
          }
      }
      .bind(to: chatRooms)
      .disposed(by: disposeBag)
    
    return Output(chatRooms: chatRooms.asDriver())
  }
}
