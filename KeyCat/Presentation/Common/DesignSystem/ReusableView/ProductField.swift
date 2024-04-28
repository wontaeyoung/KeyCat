//
//  ProductField.swift
//  KeyCat
//
//  Created by 원태영 on 4/27/24.
//

import UIKit
import SnapKit
import TextFieldEffects
import RxSwift
import RxCocoa

class ProductField: YoshikoTextField {
  
  let disposeBag = DisposeBag()
  
  init(placeholder: String? = nil, clearable: Bool = true) {
    super.init(frame: .zero)
    
    self.font = KCAsset.Font.signField
    self.placeholder = placeholder
    self.autocapitalizationType = .none
    self.autocorrectionType = .no
    self.spellCheckingType = .no
    self.tintColor = KCAsset.Color.brand
    self.clearButtonMode = clearable ? .whileEditing : .never
    self.placeholderColor = KCAsset.Color.brand
    
    self.snp.makeConstraints { make in
      make.height.equalTo(60)
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
