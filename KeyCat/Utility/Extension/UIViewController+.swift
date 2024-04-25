//
//  UIViewController+.swift
//  KeyCat
//
//  Created by 원태영 on 4/10/24.
//

import UIKit
import Toast

extension UIViewController {
  
  func hideBackTitle() -> Self {
    self.navigationItem.backButtonTitle = ""
    return self
  }
  
  func setNavigationTitle(with title: String, displayMode: UINavigationItem.LargeTitleDisplayMode) {
    self.navigationItem.title = title
    self.navigationItem.largeTitleDisplayMode = displayMode
  }
  
  func navigationTitle(with title: String, displayMode: UINavigationItem.LargeTitleDisplayMode) -> Self {
    self.navigationItem.title = title
    self.navigationItem.largeTitleDisplayMode = displayMode
    return self
  }
  
  func hideTabBar() -> Self {
    self.hidesBottomBarWhenPushed = true
    return self
  }
  
  func hideBackButton() -> Self {
    self.navigationItem.setHidesBackButton(true, animated: false)
    return self
  }
  
  func toast(_ message: String, position: ToastPosition = .center, completion: (() -> Void)? = nil) {
    view.makeToast(message, position: position) { _ in
      completion?()
    }
  }
}
