//
//  RxBaseCollectionViewCell.swift
//  KeyCat
//
//  Created by 원태영 on 4/10/24.
//

import UIKit
import RxSwift

class RxBaseCollectionViewCell: UICollectionViewCell {
  
  class var identifier: String {
    return self.description()
  }
  
  // MARK: - Property
  var disposeBag = DisposeBag()
  
  // MARK: - Initializer
  override init(frame: CGRect) {
    
    super.init(frame: frame)
    
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    
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
