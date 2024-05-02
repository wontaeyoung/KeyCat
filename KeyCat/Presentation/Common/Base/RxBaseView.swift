//
//  RxBaseView.swift
//  KeyCat
//
//  Created by 원태영 on 4/29/24.
//

import UIKit
import RxSwift

class RxBaseView: UIView {
  
  // MARK: - Property
  var disposeBag = DisposeBag()
  
  // MARK: - Initializer
  init() {
    super.init(frame: .zero)
    
    backgroundColor = KCAsset.Color.background
    setHierarchy()
    setConstraint()
    setAttribute()
    bind()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  func setHierarchy() { }
  func setConstraint() { }
  func setAttribute() { }
  func bind() { }
}
