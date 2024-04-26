//
//  MainTabBarPage.swift
//  KeyCat
//
//  Created by 원태영 on 4/26/24.
//

import UIKit

enum MainTabBarPage: Int, CaseIterable {
  
  case shopping
  case profile
  
  var index: Int {
    self.rawValue
  }
  
  var title: String {
    switch self {
      case .shopping:
        return "쇼핑"
        
      case .profile:
        return "마이페이지"
    }
  }
  
  var icon: UIImage? {
    switch self {
      case .shopping:
        return KCAsset.Symbol.shoppingTab
        
      case .profile:
        return KCAsset.Symbol.profileTab
    }
  }
  
  var selectedIcon: UIImage? {
    switch self {
      case .shopping:
        return KCAsset.Symbol.shoppingSelectedTab
        
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
