//
//  JsonCoder.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

import Foundation

final class JsonCoder {
  
  static let shared = JsonCoder()
  private init() { }
  
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  
  func encode<T: Encodable>(from value: T) throws -> Data {
    return try encoder.encode(value)
  }
  
  func decode<T: Decodable>(to type: T.Type, from data: Data) throws -> T {
    return try decoder.decode(type, from: data)
  }
}
