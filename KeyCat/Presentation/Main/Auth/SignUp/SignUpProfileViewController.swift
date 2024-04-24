//
//  SignUpProfileViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpProfileViewController: SignUpBaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var profileImageButton = UIImageView(image: profileImage.value).configured {
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
    $0.isUserInteractionEnabled = true
    $0.layer.configure {
      $0.cornerRadius = 100 / 2
      $0.borderColor = KCAsset.Color.primary.cgColor
      $0.borderWidth = 2
    }
  }
  
  private let nicknameField = SignUpInputField(inputInformation: .nickname)
  
  private let updateProfileImageAvailableLabel = KCLabel(
    style: .caption,
    title: Constant.Label.updateProfileImageAvailable,
    alignment: .center
  )
  
  // MARK: - Property
  let viewModel: SignUpViewModel
  private let profileImage = BehaviorRelay<UIImage>(value: .keyCatOpacity)
  
  // MARK: - Initializer
  init(viewModel: SignUpViewModel) {
    self.viewModel = viewModel
    
    super.init(inputInfoTitle: Constant.Label.inputProfileInfo)
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    super.setHierarchy()
    
    view.addSubviews(
      profileImageButton,
      nicknameField,
      updateProfileImageAvailableLabel
    )
  }
  
  override func setConstraint() {
    super.setConstraint()
    
    profileImageButton.snp.makeConstraints { make in
      make.top.equalTo(inputInfoTitleLabel.snp.bottom).offset(20)
      make.centerX.equalTo(view)
      make.size.equalTo(100)
    }
    
    nicknameField.snp.makeConstraints { make in
      make.top.equalTo(profileImageButton.snp.bottom)
      make.horizontalEdges.equalTo(view).inset(20)
    }
    
    updateProfileImageAvailableLabel.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(nextButton.snp.top).offset(-10)
    }
  }
  
  override func bind() {
    
    let input = SignUpViewModel.Input()
    let output = viewModel.transform(input: input)
    
    let tap = UITapGestureRecognizer()
    profileImageButton.addGestureRecognizer(tap)
    tap.rx.event
      .bind(with: self) { owner, _ in
        print("TAP")
      }
      .disposed(by: disposeBag)
    
    /// 다음 버튼 탭 이벤트 전달
    nextButton.rx.tap
      .buttonThrottle()
      .bind(to: input.passwordNextEvent)
      .disposed(by: disposeBag)
  }
}

@available(iOS 17, *)
#Preview {
  UINavigationController(rootViewController: SignUpEmailViewController(viewModel: SignUpViewModel()))
}
