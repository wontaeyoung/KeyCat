//
//  String+.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

import Foundation
import UIKit

extension String {
  var isFilled: Bool {
    return isEmpty == false
  }
  
  func isMatch(pattern: String) -> Bool {
    let isMathed: Bool = self.range(
      of: pattern,
      options: .regularExpression
    ) != nil
    
    return isMathed
  }
  
  func strikethroughAttributedString(
    strikethroughStyle: NSUnderlineStyle = .single,
    strikethroughColor: UIColor = .black
  ) -> NSAttributedString {
    let attributes: [NSAttributedString.Key: Any] = [
      .strikethroughStyle: strikethroughStyle.rawValue,
      .strikethroughColor: strikethroughColor
    ]
    
    return NSAttributedString(string: self, attributes: attributes)
  }
}
