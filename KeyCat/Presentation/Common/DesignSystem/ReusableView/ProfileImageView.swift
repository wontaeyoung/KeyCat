//
//  ProfileImageView.swift
//  KeyCat
//
//  Created by 원태영 on 5/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileImageView: TappableImageView {
  
  init(size: CGFloat) {
    super.init(image: nil)
    
    clipsToBounds = true
    layer.configure {
      $0.cornerRadius = size / 2
      $0.borderWidth = 1
      $0.borderColor = KCAsset.Color.lightGrayForeground.color.cgColor
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
