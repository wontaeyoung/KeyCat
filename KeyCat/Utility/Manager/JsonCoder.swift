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
  
  func encodeString<T: Encodable>(from value: T) throws -> String {
    let data = try encode(from: value)
    guard let jsonString = String(data: data, encoding: .utf8) else {
      throw JsonCodeError.encodeToStringFailed
    }
    
    return jsonString
  }
  
  func decodeString<T: Decodable>(from jsonString: String) throws -> T {
    guard let jsonData = jsonString.data(using: .utf8) else {
      throw JsonCodeError.decodeToDataFailed
    }
    
    return try decode(to: T.self, from: jsonData)
  }
}

enum JsonCodeError: AppError {
  case encodeToStringFailed
  case decodeToDataFailed
  
  var logDescription: String {
    switch self {
      case .encodeToStringFailed:
        return "Json 문자열로 인코딩 실패"
      case .decodeToDataFailed:
        return "Json 데이터로 디코딩 실패"
    }
  }
  
  var alertDescription: String {
    switch self {
      case .encodeToStringFailed:
        return "내용을 저장하면서 문제가 발생했어요. \(CommonError.contactDeveloperInfoText)"
      case .decodeToDataFailed:
        return "내용을 불러오면서 문제가 발생했어요. \(CommonError.contactDeveloperInfoText)"
    }
  }
}
