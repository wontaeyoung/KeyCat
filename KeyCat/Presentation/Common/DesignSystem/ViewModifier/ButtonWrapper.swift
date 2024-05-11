//
//  ButtonWrapper.swift
//  KeyCat
//
//  Created by 원태영 on 5/11/24.
//

import SwiftUI

private struct ButtonWrapper: ViewModifier {
  
  let action: () -> Void
  
  func body(content: Content) -> some View {
    
    Button(action: action) {
      content
    }
  }
}

extension View {
  
  func asButton(action: @escaping () -> Void) -> some View {
    modifier(ButtonWrapper(action: action))
  }
}
