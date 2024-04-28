//
//  UserInfoService.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

struct UserInfoService {
  
  @UserDefault(key: UserInfoKey.accessToken, defaultValue: .defaultValue)
  static var accessToken: String
  
  @UserDefault(key: UserInfoKey.refreshToken, defaultValue: .defaultValue)
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
  
  static func logout() {
    accessToken = .defaultValue
    refreshToken = .defaultValue
    hasSellerAuthority = .defaultValue
  }
}

extension UserInfoService {
  
  enum UserInfoKey: String, UserDefaultKey {
    
    case accessToken
    case refreshToken
    
    var name: String {
      return self.rawValue
    }
  }
}
