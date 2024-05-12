//
//  Font+.swift
//  KeyCat
//
//  Created by 원태영 on 5/12/24.
//

import SwiftUI

extension Font {
  
  static func medium(size: CGFloat) -> Font {
    return .custom("GmarketSansMedium", size: size)
  }
  
  static func bold(size: CGFloat) -> Font {
    return .custom("GmarketSansBold", size: size)
  }
}
