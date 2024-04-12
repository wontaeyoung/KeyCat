//
//  DefaultValueProvidable.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

public protocol DefaultValueProvidable: Decodable {
  static var defaultValue: Self { get }
}

extension String: DefaultValueProvidable {
  public static var defaultValue: String {
    return ""
  }
}

extension Double: DefaultValueProvidable {
  public static var defaultValue: Double {
    return 0.0
  }
}

extension Float: DefaultValueProvidable {
  public static var defaultValue: Float {
    return 0.0
  }
}

extension Bool: DefaultValueProvidable {
  public static var defaultValue: Bool {
    return false
  }
}

extension Int: DefaultValueProvidable {
  public static var defaultValue: Int {
    return 0
  }
}

extension Array: DefaultValueProvidable where Array.Element: DefaultValueProvidable {
  public static var defaultValue: [Array.Element] {
    return []
  }
}
