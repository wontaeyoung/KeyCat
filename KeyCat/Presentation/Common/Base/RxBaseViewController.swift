//
//  RxBaseViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/10/24.
//

import UIKit
import RxSwift

class RxBaseViewController: UIViewController {
  
  class var identifier: String {
    return self.description()
  }
  
  // MARK: - Property
  var disposeBag = DisposeBag()
  
  // MARK: - Initializer
  init() {
    super.init(nibName: nil, bundle: nil)
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
