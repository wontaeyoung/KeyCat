//
//  KCHeader.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

enum KCHeader {
  enum Key {
    static let contentType = "Content-Type"
    static let sesacKey = "SesacKey"
    static let authorization = "Authorization"
    static let refresh = "Refresh"
  }
  
  enum Value {
    static let applicationJson = "application/json"
    static let multipartFormData = "multipart/form-data"
  }
}
