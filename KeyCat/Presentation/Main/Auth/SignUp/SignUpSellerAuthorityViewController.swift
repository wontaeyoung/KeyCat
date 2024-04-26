//
//  SignUpSellerAuthorityViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpSellerAuthorityViewController: SignUpBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let updateSellerAuthorityAvailableLabel = KCLabel(
    style: .caption,
    title: Constant.Label.updateSellerAuthorityAvailable,
    alignment: .center
  )
  
  private let sellerAuthorityButton = KCButton(
    style: .secondary,
    title: Constant.Button.sellerAuthority
  )
  
  // MARK: - Property
  let viewModel: SignUpViewModel
  
  // MARK: - Initializer
  init(viewModel: SignUpViewModel) {
    self.viewModel = viewModel
    
    super.init(inputInfoTitle: Constant.Label.inputSellerAuthority)
    self.nextButton.title(Constant.Button.onlyCustomerAuthority)
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    super.setHierarchy()
    
    view.addSubviews(
      updateSellerAuthorityAvailableLabel,
      sellerAuthorityButton
    )
  }
  
  override func setConstraint() {
    super.setConstraint()
    
    updateSellerAuthorityAvailableLabel.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(sellerAuthorityButton.snp.top).offset(-10)
    }
    
    sellerAuthorityButton.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(nextButton.snp.top).offset(-20)
    }
  }
  
  override func bind() {
    
    let input = SignUpViewModel.Input()
    viewModel.transform(input: input)
    
    /// 판매자 권한 필요 버튼 탭 이벤트 전달
    sellerAuthorityButton.rx.tap
      .buttonThrottle()
      .bind(to: input.sellerAuthorityNextEvent)
      .disposed(by: disposeBag)
    
    /// 판매자 권한 필요없음 버튼 탭 이벤트 전달
    nextButton.rx.tap
      .buttonThrottle()
      .bind(to: input.onlyCustomerAuthorityNextEvent)
      .disposed(by: disposeBag)
  }
}

@available(iOS 17, *)
#Preview {
  UINavigationController(rootViewController: SignUpEmailViewController(viewModel: SignUpViewModel()))
}
