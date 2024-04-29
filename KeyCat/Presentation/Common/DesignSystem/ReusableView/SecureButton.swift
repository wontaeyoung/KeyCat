//
//  SecureButton.swift
//  KeyCat
//
//  Created by 원태영 on 4/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SecureButton: UIButton {
  
  private let disposeBag = DisposeBag()
  private let field: UITextField
  private var isSecure: Bool = true {
    didSet {
      isSecureRelay.accept(isSecure)
    }
  }
  
  private lazy var isSecureRelay = BehaviorRelay<Bool>(value: isSecure)
  
  init(field: UITextField) {
    self.field = field
    
    super.init(frame: .zero)
    
    rx.tap
      .bind(with: self) { owner, _ in
        owner.isSecure.toggle()
      }
      .disposed(by: disposeBag)
    
    isSecureRelay
      .map { $0 ? "eye.slash" : "eye" }
      .map { UIImage(systemName: $0) }
      .bind(to: rx.image())
      .disposed(by: disposeBag)
    
    isSecureRelay
      .bind(to: field.rx.isSecureTextEntry)
      .disposed(by: disposeBag)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
