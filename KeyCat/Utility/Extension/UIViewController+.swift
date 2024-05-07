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
  
  func navigationTitle(with title: String, displayMode: UINavigationItem.LargeTitleDisplayMode = .never) -> Self {
    self.navigationItem.title = title
    self.navigationItem.largeTitleDisplayMode = displayMode
    return self
  }
  
  func setKCNavigationTitle(with title: String) {
    let titleLabel = KCLabel(title: title, font: .bold(size: 24))
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel) 
  }
  
  func kcNavigationTitle(with title: String) -> Self {
    let titleLabel = KCLabel(title: title, font: .bold(size: 24))
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    return self
  }
  
  func setTabBarHidden() {
    self.hidesBottomBarWhenPushed = true
  }
  
  func hideTabBar() -> Self {
    self.hidesBottomBarWhenPushed = true
    return self
  }
  
  func hideBackButton() -> Self {
    self.navigationItem.setHidesBackButton(true, animated: false)
    return self
  }
  
  func toast(
    _ message: String,
    position: ToastPosition = .center,
    completion: (() -> Void)? = nil,
    duration: TimeInterval = 1
  ) {
    view.makeToast(message, duration: duration, position: position) { _ in
      completion?()
    }
  }
  
  func setBarItem(at position: NavigationBarPosition, item: UIBarButtonItem) {
    switch position {
      case .left:
        navigationItem.setLeftBarButton(item, animated: false)
      case .right:
        navigationItem.setRightBarButton(item, animated: false)
    }
  }
  
  func barItemAdded(at position: NavigationBarPosition, item: UIBarButtonItem) -> Self {
    switch position {
      case .left:
        navigationItem.setLeftBarButton(item, animated: false)
      case .right:
        navigationItem.setRightBarButton(item, animated: false)
    }
    
    return self
  }
  
  enum NavigationBarPosition {
    case left
    case right
  }
}
