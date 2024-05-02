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
  private lazy var imagePicker = UIImagePickerController().configured {
    $0.delegate = self
    $0.sourceType = .photoLibrary
  }
  
  private let tappableDefaultProfileImageView = TappableImageView(image: .catWithKeycap2).configured {
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
    $0.layer.configure {
      $0.cornerRadius = 100 / 2
      $0.borderColor = KCAsset.Color.primary.color.cgColor
      $0.borderWidth = 2
    }
  }
  
  private let tappableProfileImageView = TappableImageView(image: nil).configured {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.configure {
      $0.cornerRadius = 100 / 2
      $0.borderColor = KCAsset.Color.primary.color.cgColor
      $0.borderWidth = 2
    }
  }
  
  private let clearProfileImageButton = KCButton(
    style: .icon,
    image: KCAsset.Symbol.closeButton
  )
  
  private let nicknameField = ValidationField(inputInformation: .nickname)
  
  private let updateProfileImageAvailableLabel = KCLabel(
    title: Constant.Label.updateProfileImageAvailable,
    font: .medium(size: 15),
    color: .lightGrayForeground,
    line: 2,
    alignment: .center
  )
  
  // MARK: - Property
  let viewModel: SignUpViewModel
  private let profileImage = BehaviorRelay<UIImage?>(value: nil)
  
  // MARK: - Initializer
  init(viewModel: SignUpViewModel) {
    self.viewModel = viewModel
    
    super.init(inputInfoTitle: Constant.Label.inputProfileInfo)
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    super.setHierarchy()
    
    view.addSubviews(
      tappableDefaultProfileImageView,
      tappableProfileImageView,
      clearProfileImageButton,
      nicknameField,
      updateProfileImageAvailableLabel
    )
  }
  
  override func setAttribute() {
    nextButton.title(Constant.Button.signingUp)
  }
  
  override func setConstraint() {
    super.setConstraint()
    
    tappableDefaultProfileImageView.snp.makeConstraints { make in
      make.top.equalTo(inputInfoTitleLabel.snp.bottom).offset(20)
      make.centerX.equalTo(view)
      make.size.equalTo(100)
    }
    
    tappableProfileImageView.snp.makeConstraints { make in
      make.edges.equalTo(tappableDefaultProfileImageView)
    }
    
    clearProfileImageButton.snp.makeConstraints { make in
      make.top.trailing.equalTo(tappableProfileImageView).inset(3)
      make.size.equalTo(25)
    }
    
    nicknameField.snp.makeConstraints { make in
      make.top.equalTo(tappableDefaultProfileImageView.snp.bottom)
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
    
    /// 프로필 이미지 탭 이벤트
    Observable.merge(
      tappableDefaultProfileImageView.tap.asObservable(),
      tappableProfileImageView.tap.asObservable()
    )
    .bind(with: self) { owner, _ in
      owner.present(owner.imagePicker, animated: true)
    }
    .disposed(by: disposeBag)
    
    /// 프로필 이미지를 설정하지 않으면 기본 프로필 보여주기
    profileImage
      .map { $0 == nil }
      .debug()
      .bind(to: tappableProfileImageView.rx.isHidden, clearProfileImageButton.rx.isHidden)
      .disposed(by: disposeBag)
    
    /// 이미지가 변경되면 프로필 이미지뷰에 반영
    profileImage
      .bind(to: tappableProfileImageView.rx.image)
      .disposed(by: disposeBag)
    
    /// 프로필 이미지 제거 버튼 탭 이벤트 -> 프로필 이미지 삭제
    clearProfileImageButton.rx.tap
      .buttonThrottle()
      .map { nil }
      .bind(to: profileImage)
      .disposed(by: disposeBag)
    
    /// 이메일 입력 전달
    nicknameField.rx.text.orEmpty
      .bind(to: input.nickname)
      .disposed(by: disposeBag)
    
    /// 닉네임 유효성 검사 -> 다음 버튼 활성화
    nicknameField.inputValidation
      .bind(to: nextButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    /// 다음 버튼 탭 이벤트 + 현재 프로필 이미지 데이터 전달
    nextButton.rx.tap
      .buttonThrottle()
      .withUnretained(self)
      .do { owner, _ in
        owner.nextButton.showIndicator()
      }
      .withLatestFrom(profileImage)
      .map { $0?.compressedJPEGData }
      .bind(to: input.profileNextEvent)
      .disposed(by: disposeBag)
    
    /// 회원가입 완료 토스트 표시 -> 토스트 종료 이벤트 전달
    output.signUpCompleted
      .drive(with: self) { owner, _ in
        owner.toast("회원가입이 완료되었어요!") { 
          input.signUpToastCompletedEvent.accept(())
        }
      }
      .disposed(by: disposeBag)
    
    /// 회원가입 실패 시 인디케이터 중지
    output.signUpFailed
      .drive(with: self) { owner, _ in
        owner.nextButton.stopIndicator()
      }
      .disposed(by: disposeBag)
  }
}

extension SignUpProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    if let image = info[.originalImage] as? UIImage {
      profileImage.accept(image)
    }
    
    picker.dismiss(animated: true)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }
}
