//
//  KCLabel.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

import UIKit

class KCLabel: UILabel {
  
  init(
    title: String? = nil,
    font: KCAsset.Font,
    color: KCAsset.Color = .black,
    line: Int = 1,
    alignment: NSTextAlignment = .natural
  ) {
    super.init(frame: .zero)
    
    self.text = title
    self.font = font.font
    self.textColor = color.color
    self.numberOfLines = line
    self.textAlignment = alignment
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension KCLabel {
  
  func applyLineSpacing() {
    guard let text = self.text else { return }
    
    let style = NSMutableParagraphStyle().configured {
      $0.lineSpacing = 10
    }
    
    self.attributedText = NSMutableAttributedString(string: text).configured {
      let range = NSRange(location: 0, length: $0.length)
      
      $0.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
      $0.addAttribute(NSAttributedString.Key.font, value: KCAsset.Font.medium(size: 19).font, range: range)
    }
  }
}
