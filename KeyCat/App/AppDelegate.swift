//
//  AppDelegate.swift
//  KeyCat
//
//  Created by 원태영 on 4/9/24.
//

import UIKit
import Toast

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    setGlobalToastStyle()
    
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    
  }
}

extension AppDelegate {
  
  private func setGlobalToastStyle() {
    ToastManager.shared.style = ToastStyle().applied {
      $0.backgroundColor = KCAsset.Color.lightGrayBackground.color
      $0.messageColor = KCAsset.Color.black.color
      $0.messageFont = KCAsset.Font.bold(size: 15).font
      $0.titleColor = KCAsset.Color.black.color
      $0.titleFont = KCAsset.Font.bold(size: 17).font
      $0.titleAlignment = .center
      $0.activityBackgroundColor = .clear
      $0.activityIndicatorColor = KCAsset.Color.brand.color
      $0.verticalPadding = 20
      $0.horizontalPadding = 20
    }
  }
}
