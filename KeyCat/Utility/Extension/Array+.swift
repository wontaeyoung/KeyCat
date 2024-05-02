//
//  Array+.swift
//  KeyCat
//
//  Created by 원태영 on 5/1/24.
//

extension Array {
  var isFilled: Bool {
    return isEmpty == false
  }
}

extension Array where Element == CommercialReview {
  var averageScore: Double {
    let totalScore = map { $0.rating.rawValue }
      .reduce(0, +)
    
    return Double(totalScore) / Double(count)
  }
}
