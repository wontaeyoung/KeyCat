//
//  MainTabBarPage.swift
//  KeyCat
//
//  Created by 원태영 on 4/26/24.
//

import UIKit

enum MainTabBarPage: Int, CaseIterable {
  
  case home
  case shopping
  case chat
  case profile
  
  var index: Int {
    self.rawValue
  }
  
  var title: String {
    switch self {
      case .home:
        return "홈"
        
      case .shopping:
        return "쇼핑"
        
      case .chat:
        return "1:1 문의"
        
      case .profile:
        return "마이페이지"
    }
  }
  
  var icon: UIImage? {
    switch self {
      case .home:
        return KCAsset.Symbol.homeTab
        
      case .shopping:
        return KCAsset.Symbol.shoppingTab
        
      case .chat:
        return KCAsset.Symbol.chatTab
        
      case .profile:
        return KCAsset.Symbol.profileTab
    }
  }
  
  var selectedIcon: UIImage? {
    switch self {
      case .home:
        return KCAsset.Symbol.homeSelectedTab
        
      case .shopping:
        return KCAsset.Symbol.shoppingSelectedTab
        
      case .chat:
        return KCAsset.Symbol.chatSelectedTab
        
      case .profile:
        return KCAsset.Symbol.profileSelectedTab
    }
  }
  
  var tabBarItem: UITabBarItem {
    return UITabBarItem(
      title: title,
      image: icon,
      selectedImage: selectedIcon
    )
  }
}
