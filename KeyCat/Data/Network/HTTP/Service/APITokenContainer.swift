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
  
  static func login(accessToken: String, refreshToken: String) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }
  
  static func renewAccessToken(with accessToken: String) {
    self.accessToken = accessToken
  }
  
  static func clearTokens() {
    accessToken = ""
    refreshToken = ""
  }
}
