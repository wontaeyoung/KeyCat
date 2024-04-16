//
//  HTTPHeaders+.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

import Alamofire

extension HTTPHeaders {
  func combined(headers: HTTPHeaders) -> HTTPHeaders {
    var mutableHeaders = self
    headers.forEach { mutableHeaders.add($0) }
    
    return mutableHeaders
  }
}
