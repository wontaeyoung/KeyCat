//
//  APITokenContainer.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

struct APITokenContainer {
  
  @UserDefault(key: .accessToken, defaultValue: "")
  var accessToken: String
  
  @UserDefault(key: .refreshToken, defaultValue: "")
  var refreshToken: String
}
