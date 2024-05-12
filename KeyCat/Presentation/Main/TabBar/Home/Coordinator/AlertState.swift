//
//  AlertState.swift
//  KeyCat
//
//  Created by 원태영 on 5/10/24.
//

import SwiftUI

struct AlertState {
  var title: String
  var description: String
  var showing: Bool
  var okTitle: String
  var okRole: ButtonRole?
  var cancellable: Bool
  var action: (() -> Void)?
  
  init(
    title: String,
    description: String,
    showing: Bool = true,
    okTitle: String = "확인",
    okRole: ButtonRole? = nil,
    cancellable: Bool = false,
    action: (() -> Void)? = nil
  ) {
    self.title = title
    self.description = description
    self.showing = showing
    self.okTitle = okTitle
    self.okRole = okRole
    self.cancellable = cancellable
    self.action = action
  }
  
  static var empty: AlertState {
    return AlertState(
      title: "",
      description: "",
      showing: false,
      okTitle: "확인",
      okRole: nil,
      cancellable: false,
      action: nil
    )
  }
}
