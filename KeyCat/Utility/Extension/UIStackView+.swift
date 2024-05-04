//
//  UIStackView+.swift
//  KeyCat
//
//  Created by 원태영 on 4/29/24.
//

import UIKit

extension UIStackView {
  func addArrangedSubviews(_ views: UIView...) {
    views.forEach {
      addArrangedSubview($0)
    }
  }
  
  func removeArrangedSubviews(_ views: UIView...) {
    views.forEach {
      removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
  }
  
  func removeAllArrangedSubviews() {
    arrangedSubviews.forEach {
      removeArrangedSubviews($0)
    }
  }
}
