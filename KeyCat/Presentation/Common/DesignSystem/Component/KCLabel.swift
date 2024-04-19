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
  }
  
  func applyLineSpacing() {
    guard let text = self.text else { return }
    
    let style = NSMutableParagraphStyle().configured {
      $0.lineSpacing = 10
    }
    
    self.attributedText = NSMutableAttributedString(string: text).configured {
      let range = NSRange(location: 0, length: $0.length)
      
      $0.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
      $0.addAttribute(NSAttributedString.Key.font, value: KCAsset.Font.inputField, range: range)
    }
  }
}
