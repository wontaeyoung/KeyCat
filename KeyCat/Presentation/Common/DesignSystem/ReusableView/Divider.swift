//
//  Divider.swift
//  KeyCat
//
//  Created by 원태영 on 4/29/24.
//

import UIKit
import SnapKit

final class Divider: RxBaseView {
  
  init(color: UIColor = KCAsset.Color.lightGrayForeground) {
    super.init()
    
    self.backgroundColor = color
    
    snp.makeConstraints { make in
      make.height.equalTo(1)
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
