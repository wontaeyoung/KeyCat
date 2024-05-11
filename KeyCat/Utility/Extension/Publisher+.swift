//
//  Publisher+.swift
//  KeyCat
//
//  Created by 원태영 on 5/11/24.
//

import Combine

extension Publisher {
  
  func with<T: AnyObject>(_ owner: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
    compactMap { [weak owner] output in
      guard let owner else { return nil }
      
      return (owner, output)
    }
  }
}
