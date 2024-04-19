//
//  String+.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

extension String {
  func isMatch(pattern: String) -> Bool {
    let isMathed: Bool = self.range(
      of: pattern,
      options: .regularExpression
    ) != nil
    
    return isMathed
  }
}
