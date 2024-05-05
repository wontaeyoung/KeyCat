//
//  ProfileViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let profileView = ProfileView()
  private let followButton = KCButton(style: .secondary)
  private let profileTableTitleLabel = KCLabel(font: .bold(size: 18), color: .darkGray)
  private let profileTableView = UITableView().configured {
    $0.register(MyProfileTableCell.self, forCellReuseIdentifier: MyProfileTableCell.identifier)
  }
  
  // MARK: - Property
  let viewModel: ProfileViewModel
  
  // MARK: - Initializer
  init(viewModel: ProfileViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      profileView,
      followButton,
      profileTableTitleLabel,
      profileTableView
    )
  }
  
  override func setConstraint() {
    profileView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    followButton.snp.makeConstraints { make in
      make.top.equalTo(profileView.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    profileTableTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(followButton.snp.bottom).offset(40)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    profileTableView.snp.makeConstraints { make in
      make.top.equalTo(profileTableTitleLabel.snp.bottom)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    
    let input = ProfileViewModel.Input()
    let output = viewModel.transform(input: input)
    
    profileTableView.rx.modelSelected(ProfileRow.self)
      .bind(to: input.tableCellTapEvent)
      .disposed(by: disposeBag)
    
    /// 프로필 데이터 표시
    output.profile
      .bind(to: profileView.rx.profile)
      .disposed(by: disposeBag)
    
    /// 내 프로필이면 팔로우 버튼 숨김처리
    output.profile
      .map { $0.profileType == .mine }
      .bind(to: followButton.rx.isHidden)
      .disposed(by: disposeBag)
    
    /// 팔로워 포함 여부 > 팔로우 버튼 타이틀 반영
    output.profile
      .map { $0.isFollowing }
      .map { $0 ? "팔로우 취소" : "팔로우" }
      .bind(to: followButton.rx.title())
      .disposed(by: disposeBag)
    
    /// 정보 테이블 Row 설정
    output.profile
      .map { ProfileRow.rows(type: $0.profileType) }
      .asDriver(onErrorJustReturn: [])
      .drive(
        profileTableView.rx.items(
          cellIdentifier: MyProfileTableCell.identifier,
          cellType: MyProfileTableCell.self)
      ) { row, item, cell in
        
        cell.accessoryType = item.accessory
        cell.selectionStyle = .none
        cell.setData(rowType: item, profile: output.profile.value)
      }
      .disposed(by: disposeBag)
    
    /// 정보 테이블 타이틀 결정
    output.profile
      .map { $0.profileType == .mine ? "내 정보" : "\($0.nickname)님의 정보" }
      .bind(to: profileTableTitleLabel.rx.text)
      .disposed(by: disposeBag)
    
    /// 팔로우 버튼 탭 이벤트 전달
    followButton.rx.tap
      .buttonThrottle()
      .bind(to: input.followTapEvent)
      .disposed(by: disposeBag)
    
    input.viewDidLoadEvent.accept(())
  }
}

extension ProfileViewController {
  
  enum ProfileRow: Int, CaseIterable {
    
    case writingPosts
    case following
    case follower
    case bookmark
    case updateProfile
    case withdraw
    
    var title: String {
      switch self {
        case .writingPosts: "작성한 게시물"
        case .following: "팔로잉"
        case .follower: "팔로워"
        case .bookmark: "북마크"
        case .updateProfile: "내 프로필 수정"
        case .withdraw: "회원탈퇴"
      }
    }
    
    var accessory: UITableViewCell.AccessoryType {
      switch self {
        case .withdraw:
          return .none
          
        default:
          return .disclosureIndicator
      }
    }
    
    static func rows(type: Profile.ProfileType) -> [ProfileRow] {
      switch type {
        case .mine:
          return ProfileRow.allCases
          
        case .other:
          return [.writingPosts, .following, .follower]
      }
    }
  }
}
