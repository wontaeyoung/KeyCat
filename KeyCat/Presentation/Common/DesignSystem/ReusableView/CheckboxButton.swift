//
//  CheckboxButton.swift
//  KeyCat
//
//  Created by 원태영 on 4/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CheckboxButton: UIButton {
  
  private let disposeBag = DisposeBag()
  private let innerToggle: Bool
  
  private var isOnState: Bool = false {
    didSet {
      isOn.accept(isOnState)
    }
  }
  
  lazy var isOn = BehaviorRelay<Bool>(value: isOnState)
  
  init(innerToggle: Bool = true) {
    self.innerToggle = innerToggle
    super.init(frame: .zero)
    
    if innerToggle {
      rx.tap
        .bind(with: self) { owner, _ in
          owner.isOnState.toggle()
        }
        .disposed(by: disposeBag)
    }
    
    isOn
      .map { $0 ? KCAsset.Symbol.checkboxOn : KCAsset.Symbol.checkboxOff }
      .bind(to: rx.image())
      .disposed(by: disposeBag)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
