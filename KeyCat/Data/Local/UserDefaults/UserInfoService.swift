//
//  UserInfoService.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

import Foundation
import Kingfisher

struct UserInfoService {
  
  @UserDefault(key: UserInfoKey.accessToken, defaultValue: .defaultValue)
  static var accessToken: String {
    didSet { updateKingfisherHeader() }
  }
  
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
  
  static func isMyUserID(with userID: User.UserID) -> Bool {
    return userID == self.userID
  }
  
  static func updateKingfisherHeader() {
    KingfisherManager.shared.downloader.sessionConfiguration = URLSessionConfiguration.default.applied {
      $0.httpAdditionalHeaders = [
        KCHeader.Key.sesacKey: APIKey.sesacKey,
        KCHeader.Key.authorization: UserInfoService.accessToken
      ]
      
      $0.timeoutIntervalForRequest = 30
    }
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
