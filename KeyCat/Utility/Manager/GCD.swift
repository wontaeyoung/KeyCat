//
//  GCD.swift
//  KeyCat
//
//  Created by 원태영 on 4/10/24.
//

import Foundation

final class GCD {
  static func main(work: @escaping () -> Void) {
    DispatchQueue.main.async {
      work()
    }
  }
  
  static func global(work: @escaping () -> Void) {
    DispatchQueue.global().async {
      work()
    }
  }
  
  static func main(after time: Double, work: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
      work()
    }
  }
  
  static func global(after time: Double, work: @escaping () -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + time) {
      work()
    }
  }
}
