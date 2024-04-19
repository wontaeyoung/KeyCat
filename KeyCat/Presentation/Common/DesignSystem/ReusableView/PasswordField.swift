//
//  PasswordField.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordField: KCTextField {
  
  private var isSecure: Bool = true  {
    didSet {
      isSecureRelay.accept(isSecure)
    }
  }
  
  private lazy var isSecureRelay = BehaviorRelay<Bool>(value: isSecure)
  private let toggleSecureButton = UIButton()
  
  init(placeholder: String?) {
    super.init(style: .input, placeholder: placeholder, clearable: false)
    
    setLayout()
    bind()
  }
  
  private func setLayout() {
    addSubviews(toggleSecureButton)
    
    toggleSecureButton.snp.makeConstraints { make in
      make.trailing.equalTo(self).inset(5)
      make.bottom.equalTo(self).inset(5)
      make.size.equalTo(25)
    }
  }
  
  private func bind() {
    isSecureRelay
      .map { $0 ? "eye.slash" : "eye" }
      .map { UIImage(systemName: $0) }
      .bind(to: toggleSecureButton.rx.image())
      .disposed(by: disposeBag)
    
    isSecureRelay
      .bind(to: rx.isSecureTextEntry)
      .disposed(by: disposeBag)
    
    toggleSecureButton.rx.tap
      .bind(with: self) { owner, _ in
        owner.isSecure.toggle()
      }
      .disposed(by: disposeBag)
  }
}
