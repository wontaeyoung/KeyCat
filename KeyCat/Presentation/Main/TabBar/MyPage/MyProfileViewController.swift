//
//  MyProfileViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyProfileViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let profileView = ProfileView()
  private let profileTableTitleLabel = KCLabel(title: "내 정보", font: .bold(size: 18), color: .darkGray)
  private let profileTableView = UITableView().configured {
    $0.register(MyProfileTableCell.self, forCellReuseIdentifier: MyProfileTableCell.identifier)
  }
  
  // MARK: - Property
  let viewModel: MyProfileViewModel
  
  // MARK: - Initializer
  init(viewModel: MyProfileViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      profileView,
      profileTableTitleLabel,
      profileTableView
    )
  }
  
  override func setConstraint() {
    profileView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    profileTableTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(profileView.snp.bottom).offset(40)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    profileTableView.snp.makeConstraints { make in
      make.top.equalTo(profileTableTitleLabel.snp.bottom)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    
    let input = MyProfileViewModel.Input()
    let output = viewModel.transform(input: input)
    
    profileTableView.rx.modelSelected(ProfileRow.self)
      .bind(to: input.tableCellTapEvent)
      .disposed(by: disposeBag)
    
    /// 프로필 데이터 표시
    output.profile
      .bind(to: profileView.rx.profile)
      .disposed(by: disposeBag)
    
    output.profile
      .map { _ in ProfileRow.allCases }
      .asDriver(onErrorJustReturn: [])
      .drive(
        profileTableView.rx.items(
          cellIdentifier: MyProfileTableCell.identifier,
          cellType: MyProfileTableCell.self)
      ) { row, item, cell in
        
        cell.setData(rowType: item, profile: output.profile.value)
        cell.selectionStyle = .none
        cell.accessoryType = item.accessory
      }
      .disposed(by: disposeBag)
    
    input.viewDidLoadEvent.accept(())
    
    
  }
}

extension MyProfileViewController {

  enum ProfileSection: String, CaseIterable {
    
    case list = "리스트"
    case myInfo = "내 정보"
    
    var title: String {
      return self.rawValue
    }
  }

  enum ProfileRow: Int, CaseIterable {
    
    case myPosts
    case following
    case follower
    case bookmark
    case updateProfile
    case withdraw
    
    var title: String {
      switch self {
        case .myPosts: "내 게시물"
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
    
    static func rows(section: ProfileSection) -> [ProfileRow] {
      switch section {
        case .list:
          return [.myPosts, .following, .follower, .bookmark]
        case .myInfo:
          return [.updateProfile, .withdraw]
      }
    }
  }
}
