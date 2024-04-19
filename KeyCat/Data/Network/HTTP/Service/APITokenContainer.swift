//
//  APITokenContainer.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

struct APITokenContainer {
  
  @UserDefault(key: .accessToken, defaultValue: "")
  static var accessToken: String
  
  @UserDefault(key: .refreshToken, defaultValue: "")
  static var refreshToken: String
  
  static var hasSignInLog: Bool {
    return !accessToken.isEmpty && !refreshToken.isEmpty
  }
  
  static func clearTokens() {
    accessToken = ""
    refreshToken = ""
  }
}
