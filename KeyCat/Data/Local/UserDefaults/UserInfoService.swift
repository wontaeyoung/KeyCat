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
  
  @UserDefault(key: UserInfoKey.hasSellerAuthority, defaultValue: .defaultValue)
  static var hasSellerAuthority: Bool
  
  @UserDefault(key: UserInfoKey.userID, defaultValue: .defaultValue)
  static var userID: String
  
  static var hasSignInLog: Bool {
    return accessToken.isFilled && refreshToken.isFilled
  }
  
  static func login(accessToken: String, refreshToken: String, userID: String) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.userID = userID
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
    case hasSellerAuthority
    case userID
    
    var name: String {
      return self.rawValue
    }
  }
}
