//
//  KCField.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

import UIKit
import SnapKit
import TextFieldEffects
import RxSwift
import RxCocoa

class KCField: HoshiTextField {
  
  let disposeBag = DisposeBag()
  
  init(placeholder: String? = nil, clearable: Bool = true) {
    super.init(frame: .zero)
    
    self.font = KCAsset.Font.medium(size: 19).font
    self.placeholder = placeholder
    self.autocapitalizationType = .none
    self.autocorrectionType = .no
    self.spellCheckingType = .no
    self.tintColor = KCAsset.Color.brand.color
    self.clearButtonMode = clearable ? .whileEditing : .never
    self.placeholderColor = KCAsset.Color.darkGray.color
    self.borderActiveColor = KCAsset.Color.brand.color
    self.borderInactiveColor = KCAsset.Color.lightGrayForeground.color
    
    self.snp.makeConstraints { make in
      make.height.equalTo(60)
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension KCField: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard string.isFilled else { return true }
    
    return string.isMatch(pattern: #"^[0-9]+$"#)
  }
}
