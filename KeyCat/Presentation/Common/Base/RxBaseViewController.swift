//
//  RxBaseViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/10/24.
//

import UIKit
import RxSwift
import RxCocoa

class RxBaseViewController: UIViewController {
  
  class var identifier: String {
    return self.description()
  }
  
  // MARK: - Property
  var disposeBag = DisposeBag()
  let tap = PublishRelay<Void>()
  
  // MARK: - Initializer
  init() {
    super.init(nibName: nil, bundle: nil)
    
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
  
  // MARK: - Life Cycle
  func setHierarchy() { }
  func setConstraint() { }
  func setAttribute() { }
  func bind() { }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    view.backgroundColor = KCAsset.Color.background
    
    setHierarchy()
    setConstraint()
    setAttribute()
    bind()
  }
}
