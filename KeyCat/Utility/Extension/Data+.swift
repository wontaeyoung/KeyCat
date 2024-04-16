//
//  Data+.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

import Foundation

extension Data {
  var toPrettyJsonString: String {
    guard
       let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
       let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
       let prettyString = String(data: prettyData, encoding: .utf8) 
    else {
      return "-"
    }
    
    return prettyString
  }
}
