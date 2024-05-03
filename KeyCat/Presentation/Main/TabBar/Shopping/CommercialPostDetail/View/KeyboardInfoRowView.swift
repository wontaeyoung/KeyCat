//
//  KeyboardInfoRowView.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class KeyboardInfoRowView<T: SelectionExpressible>: RxBaseView {
  
  private let titleLabel = KCLabel(font: .bold(size: 14))
  private let contentLabel = KCLabel(font: .medium(size: 14))
  
  var info: T? {
    didSet {
      self.contentLabel.text = info?.name
    }
  }
  
  init(type: T.Type) {
    
    super.init()
    
    titleLabel.text = type.title
  }
  
  override func setHierarchy() {
    addSubviews(
      titleLabel,
      contentLabel
    )
  }
  
  override func setConstraint() {
    snp.makeConstraints { make in
      make.height.equalTo(contentLabel)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.centerY.equalToSuperview()
    }
    
    contentLabel.snp.makeConstraints { make in
      make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing)
      make.trailing.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
