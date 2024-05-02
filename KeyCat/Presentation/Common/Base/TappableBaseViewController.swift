//
//  TappableBaseViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TappableBaseViewController: RxBaseViewController {
  
  // MARK: - Property
  let tap = PublishRelay<Void>()
  
  // MARK: - Initializer
  override init() {
    super.init()
    
    let tapGesture = UITapGestureRecognizer()
    view.addGestureRecognizer(tapGesture)
    
    tapGesture.rx.event
      .buttonThrottle(seconds: 1)
      .map { _ in () }
      .bind(to: tap)
      .disposed(by: disposeBag)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
