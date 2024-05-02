//
//  SignInViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import TextFieldEffects

final class SignInViewController: TappableBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let appLogoImageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFit
    $0.image = .keyCatOpacity
  }
  
  private let appLogoLabel = KCLabel(
    title: Constant.Label.appName,
    font: .bold(size: 50),
    color: .brand,
    alignment: .center
  )
  
  private let emailField =
  KCField(placeholder: InputInformation.email.title)
  
  private let passwordField = KCField(placeholder: InputInformation.password.title, clearable: false)
  
  private lazy var secureButton = SecureButton(field: passwordField)
  
  private let signInButton = KCButton(style: .primary, title: Constant.Button.signIn)
  
  private let signUpView = UIView()
  
  private let signUpInfoLabel = KCLabel(
    title: Constant.Label.signUpInfo,
    font: .medium(size: 15),
    color: .lightGrayForeground,
    line: 2,
    alignment: .right
  )
  
  private let signUpButton = KCButton(style: .plain, title: Constant.Button.signUp)
  
  
  // MARK: - Property
  let viewModel: SignInViewModel
  private let endEditEvnet = PublishRelay<Void>()
  
  // MARK: - Initializer
  init(viewModel: SignInViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      appLogoImageView,
      appLogoLabel,
      emailField,
      passwordField,
      secureButton,
      signInButton,
      signUpView
    )
    
    signUpView.addSubviews(
      signUpInfoLabel,
      signUpButton
    )
  }
  
  override func setConstraint() {
    appLogoImageView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.centerX.equalTo(view)
      make.size.equalTo(200)
    }
    
    appLogoLabel.snp.makeConstraints { make in
      make.top.equalTo(appLogoImageView.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(view).inset(20)
    }
    
    emailField.snp.makeConstraints { make in
      make.top.equalTo(appLogoLabel.snp.bottom)
      make.horizontalEdges.equalTo(view).inset(40)
    }
    
    passwordField.snp.makeConstraints { make in
      make.top.equalTo(emailField.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(view).inset(40)
    }
    
    secureButton.snp.makeConstraints { make in
      make.trailing.equalTo(passwordField).offset(-5)
      make.bottom.equalTo(passwordField).offset(-5)
    }
    
    signInButton.snp.makeConstraints { make in
      make.top.equalTo(passwordField.snp.bottom).offset(40)
      make.horizontalEdges.equalTo(view).inset(40)
    }
    
    signUpView.snp.makeConstraints { make in
      make.top.equalTo(signInButton.snp.bottom).offset(20)
      make.centerX.equalTo(view)
    }
    
    signUpInfoLabel.snp.makeConstraints { make in
      make.verticalEdges.equalTo(signUpView)
      make.leading.equalTo(signUpView)
    }
    
    signUpButton.snp.makeConstraints { make in
      make.verticalEdges.equalTo(signUpView)
      make.leading.equalTo(signUpInfoLabel.snp.trailing)
      make.trailing.equalTo(signUpView)
    }
  }
  
  override func bind() {
    
    let input = SignInViewModel.Input(
      email: .init(),
      password: .init(),
      loginButtonTapEvent: .init(),
      signUpButtonTapEvent: .init()
    )
    
    let output = viewModel.transform(input: input)
    
    /// 로그인 버튼 enable 연결
    output.loginEnable
      .drive(signInButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    /// 이메일 전달
    emailField.rx.text.orEmpty
      .bind(to: input.email)
      .disposed(by: disposeBag)
    
    /// 패스워드 전달
    passwordField.rx.text.orEmpty
      .bind(to: input.password)
      .disposed(by: disposeBag)
    
    /// 로그인 버튼 이벤트 전달
    signInButton.rx.tap
      .buttonThrottle()
      .bind(to: input.loginButtonTapEvent)
      .disposed(by: disposeBag)
    
    /// 회원가입 버튼 이벤트 전달
    signUpButton.rx.tap
      .buttonThrottle()
      .bind(to: input.signUpButtonTapEvent)
      .disposed(by: disposeBag)
    
    /// Responder 해제 이벤트
    endEditEvnet
      .bind(with: self) { owner, _ in
        owner.view.endEditing(true)
        owner.updateLogoSize(editing: false)
      }
      .disposed(by: disposeBag)
    
    /// 이메일 필드 submit EndEditEvent 연결
    emailField.rx.controlEvent(.editingDidEndOnExit)
      .bind(to: endEditEvnet)
      .disposed(by: disposeBag)
    
    /// 패스워드 필드 submit EndEditEvent 연결
    passwordField.rx.controlEvent(.editingDidEndOnExit)
      .bind(to: endEditEvnet)
      .disposed(by: disposeBag)
    
    /// 뷰 탭 제스처 EndEditEvent 연결
    tap
      .bind(to: endEditEvnet)
      .disposed(by: disposeBag)
    
    /// 이메일 필드 활성화 > 로고 사이즈 조정
    emailField.rx.controlEvent(.editingDidBegin)
      .bind(with: self) { owner, _ in
        owner.updateLogoSize(editing: true)
      }
      .disposed(by: disposeBag)
    
    /// 비밀번호 필드 활성화 > 로고 사이즈 조정
    passwordField.rx.controlEvent(.editingDidBegin)
      .bind(with: self) { owner, _ in
        owner.updateLogoSize(editing: true)
      }
      .disposed(by: disposeBag)
  }
  
  private func updateLogoSize(editing: Bool) {
    
    UIView.animate(withDuration: 0.5) { [weak self] in
      guard let self else { return }
      
      appLogoImageView.snp.updateConstraints { make in
        make.size.equalTo(editing ? 80 : 200)
      }
      
      appLogoLabel.snp.updateConstraints { make in
        make.top.equalTo(self.appLogoImageView.snp.bottom).offset(editing ? 0 : 20)
      }
      
      let scale: CGFloat = editing ? 0.6 : 1.0
      appLogoLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
      
      view.layoutIfNeeded()
    }
  }
}

@available(iOS 17, *)
#Preview {
  return SignInViewController(viewModel: SignInViewModel())
}
