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
    let viewWillAppearEvent: PublishRelay<Void>
    let tableCellTapEvent: PublishRelay<ProfileViewController.ProfileRow>
    let followTapEvent: PublishRelay<Void>
    
    init(
      viewDidLoadEvent: PublishRelay<Void> = .init(),
      viewWillAppearEvent: PublishRelay<Void> = .init(),
      tableCellTapEvent: PublishRelay<ProfileViewController.ProfileRow> = .init(),
      followTapEvent: PublishRelay<Void> = .init()
    ) {
      self.viewDidLoadEvent = viewDidLoadEvent
      self.viewWillAppearEvent = viewWillAppearEvent
      self.tableCellTapEvent = tableCellTapEvent
      self.followTapEvent = followTapEvent
    }
  }
  
  struct Output {
    let profile: BehaviorRelay<Profile>
    let isFollowing: Driver<Bool>
    let otherProfileFollowerCount: Driver<Int>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: MyPageCoordinator?
  private let fetchProfileUsecase: any ProfileUsecase
  private let userInteractionUsecase: any UserInteractionUsecase
  private let signUsecase: any SignUsecase
  
  private let userID: User.UserID
  private let myProfile = BehaviorRelay<Profile>(value: .empty)
  private let profile = BehaviorRelay<Profile>(value: .empty)
  private let signOutTrigger = PublishRelay<Void>()
  private let withdrawTrigger = PublishRelay<Void>()
  
  // MARK: - Initializer
  init(
    fetchProfileUsecase: any ProfileUsecase,
    userInteractionUsecase: any UserInteractionUsecase,
    signUsecase: any SignUsecase,
    userID: User.UserID
  ) {
    self.fetchProfileUsecase = fetchProfileUsecase
    self.userInteractionUsecase = userInteractionUsecase
    self.signUsecase = signUsecase
    self.userID = userID
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let myProfileFetchCompleteEvent = PublishRelay<Void>()
    let isFollowing = BehaviorRelay<Bool>(value: profile.value.isFollowing)
    let otherProfileFollwerCount = BehaviorRelay<Int>(value: profile.value.followers.count)
    
    /// 프로필의 팔로우 변경사항 반영
    profile
      .map { $0.isFollowing }
      .bind(to: isFollowing)
      .disposed(by: disposeBag)
    
    /// 프로필의 팔로워 수 변경사항 반영
    profile
      .map { $0.followers.count }
      .bind(to: otherProfileFollwerCount)
      .disposed(by: disposeBag)
    
    /// 로그아웃 > 로그인 화면 전환
    signOutTrigger
      .bind(with: self) { owner, _ in
        owner.coordinator?.signOut(nil)
      }
      .disposed(by: disposeBag)
    
    /// 회원탈퇴 호출 > 로그인 화면 전환
    withdrawTrigger
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.signUsecase.withdraw()
          .catch {
            owner.coordinator?.showErrorAlert(error: $0)
            return .never()
          }
      }
      .bind(with: self) { owner, _ in
        owner.coordinator?.signOut(nil)
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
    
    /// 화면 로드 > 내 프로필 갱신
    input.viewWillAppearEvent
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
    
    /// 프로필 셀 탭 이벤트 핸들링
    input.tableCellTapEvent
      .bind(with: self) { owner, row in
        owner.handleProfileRowTapEvent(with: row, profile: owner.profile)
      }
      .disposed(by: disposeBag)
    
    /// 팔로우 탭 이벤트 핸들링
    input.followTapEvent
      .do(onNext: { _ in
        // 옵티미스틱
        let addingCount = isFollowing.value ? -1 : 1
        
        otherProfileFollwerCount.accept(otherProfileFollwerCount.value + addingCount)
        isFollowing.accept(!isFollowing.value)
      })
      .debounce(.seconds(2), scheduler: MainScheduler.instance)
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
      profile: profile,
      isFollowing: isFollowing.asDriver(),
      otherProfileFollowerCount: otherProfileFollwerCount.asDriver()
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
        coordinator?.connectUpdateProfileFlow(profile: profile.value)
      case .signOut:
        showSignOutAlert()
      case .withdraw:
        showWithdrawAlert()
    }
  }
  
  private func showSignOutAlert() {
    
    coordinator?.showAlert(
      title: "로그아웃",
      message: "로그아웃 하시겠어요?",
      okStyle: .destructive,
      isCancelable: true
    ) {
      self.signOutTrigger.accept(())
    }
  }
  
  private func showWithdrawAlert() {
    
    coordinator?.showAlert(
      title: "회원 탈퇴 안내",
      message: "회원 탈퇴 후에는 계정을 다시 복구할 수 없어요. 정말 탈퇴하시겠어요?",
      okStyle: .destructive,
      isCancelable: true
    ) {
      self.withdrawTrigger.accept(())
    }
  }
}
