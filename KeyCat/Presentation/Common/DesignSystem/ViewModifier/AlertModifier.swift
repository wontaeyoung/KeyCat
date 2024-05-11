//
//  AlertModifier.swift
//  KeyCat
//
//  Created by 원태영 on 5/11/24.
//

import SwiftUI

private struct AlertModifier: ViewModifier {
  
  @Binding var alert: Alert
  
  func body(content: Content) -> some View {
    content
      .alert(
        alert.title,
        isPresented: $alert.showing
      ) {
        Button(alert.okTitle, role: alert.okRole) {
          alert.action?()
        }
        
        if alert.cancellable {
          Button("취소", role: .cancel) { }
        }
      } message: {
        Text(alert.description)
      }
  }
}

extension View {
  
  func alert(_ alert: Binding<Alert>) -> some View {
    modifier(AlertModifier(alert: alert))
  }
}
