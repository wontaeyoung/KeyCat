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
}

extension KCButton {
  
  enum Style {
    case primary
    
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
    
    var configuration: UIButton.Configuration {
      switch self {
        case .primary:
          return Style.primaryConfig
      }
    }
  }
}