//
//  UserDefaultManager.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

import Foundation

protocol UserDefaultKey where Self: RawRepresentable, Self.RawValue == String {
  
  var name: String { get }
}

@propertyWrapper
struct UserDefault<T: Codable> {
  
  private let key: any UserDefaultKey
  private let defaultValue: T
  private let userDefault: UserDefaults
  
  init(
    key: any UserDefaultKey,
    defaultValue: T,
    userDefault: UserDefaults = .standard
  ) {
    self.key = key
    self.defaultValue = defaultValue
    self.userDefault = userDefault
  }
  
  var wrappedValue: T {
    get {
      guard
        let data = userDefault.data(forKey: key.name),
        let value = try? JsonCoder.shared.decode(to: T.self, from: data)
      else {
        return defaultValue
      }
      
      return value
    }
    set {
      let data: Data? = try? JsonCoder.shared.encode(from: newValue)
      
      userDefault.set(data, forKey: key.name)
    }
  }
}
