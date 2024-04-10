//
//  UIView+.swift
//  KeyCat
//
//  Created by 원태영 on 4/10/24.
//

import UIKit

extension UIView {
  func addSubviews(_ view: UIView...) {
    view.forEach { self.addSubview($0) }
  }
}
