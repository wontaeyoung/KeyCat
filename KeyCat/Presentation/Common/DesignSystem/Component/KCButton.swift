//
//  KCButton.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

import UIKit

final class KCButton: UIButton {
  
  init(style: Style, title: String? = nil, image: UIImage? = nil) {
    super.init(frame: .zero)
    
    self.configuration = style.configuration.applied {
      $0.title = title
      $0.image = image
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func title(_ title: String) {
    self.configuration?.title = title
  }
  
  func image(_ image: UIImage) {
    self.configuration?.image = image
  }
  
  func showIndicator() {
    self.configuration?.showsActivityIndicator = true
  }
  
  func stopIndicator() {
    self.configuration?.showsActivityIndicator = false
  }
}

extension KCButton {
  
  enum Style {
    
    case primary
    case secondary
    case plain
    case icon
    case iconWithText
    
    private static let primaryConfig: UIButton.Configuration = .filled().applied {
      
      $0.baseForegroundColor = .white
      $0.baseBackgroundColor = KCAsset.Color.brand
      $0.buttonSize = .large
      $0.cornerStyle = .capsule
      $0.imagePadding = 6
      
      $0.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
        return $0.applied { $0.font = KCAsset.Font.buttonTitle }
      }
    }
    
    private static let secondaryConfig: UIButton.Configuration = .tinted().applied {
      
      $0.baseForegroundColor = KCAsset.Color.brand
      $0.baseBackgroundColor = KCAsset.Color.secondary
      $0.buttonSize = .large
      $0.cornerStyle = .capsule
      $0.imagePadding = 6
      
      $0.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
        return $0.applied { $0.font = KCAsset.Font.buttonTitle }
      }
    }
    
    private static let plainConfig: UIButton.Configuration = .plain().applied {
      
      $0.baseForegroundColor = KCAsset.Color.brand
      $0.buttonSize = .mini
      
      $0.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
        return $0.applied { $0.font = KCAsset.Font.captionLabel }
      }
    }
    
    private static let iconConfig: UIButton.Configuration = .plain().applied {
      
      $0.cornerStyle = .capsule
      $0.buttonSize = .small
    }
    
    private static let iconWithTextConfig: UIButton.Configuration = .plain().applied {
      
      $0.imagePlacement = .top
      $0.imagePadding = 10
    }
    
    var configuration: UIButton.Configuration {
      switch self {
        case .primary:
          return Style.primaryConfig
          
        case .secondary:
          return Style.secondaryConfig
          
        case .plain:
          return Style.plainConfig
          
        case .icon:
          return Style.iconConfig
          
        case .iconWithText:
          return Style.iconWithTextConfig
      }
    }
  }
}
