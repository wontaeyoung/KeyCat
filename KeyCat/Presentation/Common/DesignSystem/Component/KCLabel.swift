//
//  KCLabel.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

import UIKit

class KCLabel: UILabel {
  
  private let style: Style
  
  override var text: String? {
    didSet {
      
    }
  }
  
  init(style: Style, title: String? = nil, alignment: NSTextAlignment = .natural) {
    self.style = style
    
    super.init(frame: .zero)
    
    self.text = title
    self.textAlignment = alignment
    
    switch style {
      case .caption:
        self.configure {
          $0.font = KCAsset.Font.captionLabel
          $0.textColor = KCAsset.Color.lightGrayForeground
          $0.numberOfLines = 2
        }
        
      case .placeholder:
        self.configure {
          $0.font = KCAsset.Font.inputFieldPlaceholder
          $0.textColor = KCAsset.Color.darkGray
          $0.numberOfLines = 1
        }
        
      case .logo:
        self.configure {
          $0.font = KCAsset.Font.appLogoLabel
          $0.textColor = KCAsset.Color.brand
          $0.numberOfLines = 1
        }
        
      case .brandTitle:
        self.configure {
          $0.font = KCAsset.Font.title
          $0.textColor = KCAsset.Color.brand
          $0.numberOfLines = 2
        }
        
      case .blackTitle:
        self.configure {
          $0.font = KCAsset.Font.title
          $0.textColor = KCAsset.Color.black
          $0.numberOfLines = 1
        }
        
      case .sectionTitle:
        self.configure {
          $0.font = KCAsset.Font.sectionTitle
          $0.textColor = KCAsset.Color.darkGray
          $0.numberOfLines = 1
        }
        
      case .standardTitle:
        self.configure {
          $0.font = KCAsset.Font.standardTitle
          $0.textColor = KCAsset.Color.black
          $0.numberOfLines = 1
        }
        
      case .productCellTitle:
        self.configure {
          $0.font = KCAsset.Font.contentText
          $0.textColor = KCAsset.Color.black
          $0.numberOfLines = 2
        }
        
      case .productCellPrice:
        self.configure {
          $0.font = KCAsset.Font.mini
          $0.textColor = KCAsset.Color.lightGrayForeground
          $0.numberOfLines = 1
        }
        
      case .reviewScore:
        self.configure {
          $0.font = KCAsset.Font.mini
          $0.textColor = KCAsset.Color.black
          $0.numberOfLines = 1
        }
        
      case .reviewCount:
        self.configure {
          $0.font = KCAsset.Font.mini
          $0.textColor = KCAsset.Color.lightGrayForeground
          $0.numberOfLines = 1
        }
        
      case .tag:
        self.configure {
          $0.font = KCAsset.Font.tag
          $0.textColor = KCAsset.Color.white
          $0.numberOfLines = 1
        }
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension KCLabel {
  
  enum Style {
    case caption
    case placeholder
    case logo
    case brandTitle
    case blackTitle
    case sectionTitle
    case standardTitle
    case productCellTitle
    case productCellPrice
    case reviewScore
    case reviewCount
    case tag
  }
  
  func applyLineSpacing() {
    guard let text = self.text else { return }
    
    let style = NSMutableParagraphStyle().configured {
      $0.lineSpacing = 10
    }
    
    self.attributedText = NSMutableAttributedString(string: text).configured {
      let range = NSRange(location: 0, length: $0.length)
      
      $0.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
      $0.addAttribute(NSAttributedString.Key.font, value: KCAsset.Font.signField, range: range)
    }
  }
}
