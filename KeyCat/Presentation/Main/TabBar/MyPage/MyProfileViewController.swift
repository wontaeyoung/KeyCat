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
      profileView
    )
  }
  
  override func setConstraint() {
    profileView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  override func bind() {
    
    let input = MyProfileViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 프로필 데이터 표시
    output.profile
      .drive(profileView.profile)
      .disposed(by: disposeBag)
    
    input.viewDidLoadEvent.accept(())
  }
}
