//
//  ProfileViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let viewDidLoadEvent: PublishRelay<Void>
    let tableCellTapEvent: PublishRelay<ProfileViewController.ProfileRow>
    let followTapEvent: PublishRelay<Void>
    
    init(
      viewDidLoadEvent: PublishRelay<Void> = .init(),
      tableCellTapEvent: PublishRelay<ProfileViewController.ProfileRow> = .init(),
      followTapEvent: PublishRelay<Void> = .init()
    ) {
      self.viewDidLoadEvent = viewDidLoadEvent
      self.tableCellTapEvent = tableCellTapEvent
      self.followTapEvent = followTapEvent
    }
  }
  
  struct Output {
    let profile: BehaviorRelay<Profile>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: MyPageCoordinator?
  private let fetchProfileUsecase: any FetchProfileUsecase
  private let userInteractionUsecase: any UserInteractionUsecase
  
  private let userID: User.UserID
  private let myProfile = BehaviorRelay<Profile>(value: .empty)
  private let profile = BehaviorRelay<Profile>(value: .empty)
  
  // MARK: - Initializer
  init(
    userID: User.UserID,
    fetchProfileUsecase: any FetchProfileUsecase = FetchProfileUsecaseImpl(),
    userInteractionUsecase: any UserInteractionUsecase = UserInteractionUsecaseImpl()
  ) {
    self.userID = userID
    self.fetchProfileUsecase = fetchProfileUsecase
    self.userInteractionUsecase = userInteractionUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let myProfileFetchCompleteEvent = PublishRelay<Void>()
    
    /// 화면 로드 > 내 프로필 갱신
    input.viewDidLoadEvent
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.fetchProfileUsecase.fetchMyProfile()
          .catch {
            owner.coordinator?.showErrorAlert(error: $0)
            return .never()
          }
      }
      .bind(with: self) { owner, myProfile in
        owner.myProfile.accept(myProfile)
        myProfileFetchCompleteEvent.accept(())
      }
      .disposed(by: disposeBag)
    
    /// 내 프로필 화면이면 조회 결과 공유, 상대 프로필이면 신규 조회
    myProfileFetchCompleteEvent
      .map { UserInfoService.isMyUserID(with: self.userID) }
      .withUnretained(self)
      .flatMap { owner, isMine in
        
        return isMine
        ? .just(owner.myProfile.value)
        : owner.fetchProfileUsecase.fetchOtherProfile(userID: self.userID)
          .catch {
            owner.coordinator?.showErrorAlert(error: $0)
            return .never()
          }
      }
      .bind(to: profile)
      .disposed(by: disposeBag)
    
    /// 프로필 셀 탭 이벤트 핸들링
    input.tableCellTapEvent
      .bind(with: self) { owner, row in
        owner.handleProfileRowTapEvent(with: row, profile: owner.profile)
      }
      .disposed(by: disposeBag)
    
    /// 팔로우 탭 이벤트 핸들링
    input.followTapEvent
      .withLatestFrom(profile)
      .withUnretained(self)
      .flatMap { owner, profile in
        let profile = profile.isFollowing
        ? owner.userInteractionUsecase.unfollow(userID: profile.userID)
        : owner.userInteractionUsecase.follow(userID: profile.userID)
        
        return profile
          .catch {
            owner.coordinator?.showErrorAlert(error: $0)
            return .never()
          }
      }
      .bind(with: self) { owner, status in
        owner.updateFollowInProfile(status: status)
      }
      .disposed(by: disposeBag)
    
    return Output(
      profile: profile
    )
  }
  
  private func updateFollowInProfile(status: Bool) {
    
    var myProfile = myProfile.value
    var otherProfile = profile.value
    
    if status {
      myProfile.following.append(makeUser(from: otherProfile))
      otherProfile.followers.append(makeUser(from: myProfile))
    } else {
      
      guard
        let myProfileIndex = otherProfile.followers.map({ $0.userID }).firstIndex(of: UserInfoService.userID),
        let otherProfileIndex = myProfile.following.map({ $0.userID }).firstIndex(of: otherProfile.userID)
      else {
        return
      }
      
      myProfile.following.remove(at: otherProfileIndex)
      otherProfile.followers.remove(at: myProfileIndex)
    }
    
    self.myProfile.accept(myProfile)
    self.profile.accept(otherProfile)
  }
  
  private func makeUser(from profile: Profile) -> User {
    return User(userID: profile.userID, nickname: profile.nickname, profileImageURLString: profile.profileImageURLString)
  }
  
  private func handleProfileRowTapEvent(with row: ProfileViewController.ProfileRow, profile: BehaviorRelay<Profile>) {
    switch row {
      case .writingPosts:
        coordinator?.showPostListView(userID: profile.value.userID, postCase: .createdBy)
      case .following:
        coordinator?.showFollowListView(profile: profile, myProfile: myProfile, followTab: .following)
      case .follower:
        coordinator?.showFollowListView(profile: profile, myProfile: myProfile, followTab: .follower)
      case .bookmark:
        coordinator?.showPostListView(userID: profile.value.userID, postCase: .bookmark)
      case .updateProfile:
        break
      case .signOut:
        break
      case .withdraw:
        break
    }
  }
}
