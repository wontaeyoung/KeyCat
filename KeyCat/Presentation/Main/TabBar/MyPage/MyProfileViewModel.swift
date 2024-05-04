//
//  MyProfileViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift
import RxCocoa

final class MyProfileViewModel: ViewModel {
  
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
    let profile: Driver<Profile>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: MyPageCoordinator?
  private let fetchProfileUsecase: any FetchProfileUsecase
  
  // MARK: - Initializer
  init(
    fetchProfileUsecase: any FetchProfileUsecase = FetchProfileUsecaseImpl()
  ) {
    self.fetchProfileUsecase = fetchProfileUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let profile = PublishRelay<Profile>()
    
    /// 화면 진입 이벤트 > 프로필 조회 호출
    input.viewDidLoadEvent
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.fetchProfileUsecase.fetchMyProfile()
      }
      .bind(to: profile)
      .disposed(by: disposeBag)
    
    return Output(
      profile: profile.asDriver(onErrorJustReturn: .empty)
    )
  }
}
