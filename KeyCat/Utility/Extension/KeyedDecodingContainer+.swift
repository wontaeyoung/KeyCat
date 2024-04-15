//
//  KeyedDecodingContainer+.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

extension KeyedDecodingContainer {
  func decodeWithDefaultValue<T: DefaultValueProvidable>(
    _ type: T.Type,
    forKey key: KeyedDecodingContainer<K>.Key
  ) throws -> T {
    return try decodeIfPresent(type, forKey: key) ?? .defaultValue
  }
}
