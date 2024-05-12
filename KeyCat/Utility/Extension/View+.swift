//
//  View+.swift
//  KeyCat
//
//  Created by 원태영 on 5/11/24.
//

import SwiftUI

extension View {
  
  func frame(size: CGFloat) -> some View {
    frame(width: size, height: size)
  }
  
  func horizontalFilled() -> some View {
    frame(maxWidth: .infinity)
  }
}
