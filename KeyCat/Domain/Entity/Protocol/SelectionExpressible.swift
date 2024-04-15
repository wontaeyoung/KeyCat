//
//  SelectionExpressible.swift
//  KeyCat
//
//  Created by 원태영 on 4/13/24.
//

protocol SelectionExpressible: CaseIterable, RawRepresentable where Self.RawValue == Int {
  static var coalesce: Self { get }
  var name: String { get }
  static var title: String { get }
  static var selection: [Self] { get }
  
  init(_ rawValue: RawValue)
}

extension SelectionExpressible {
  static var selection: [Self] {
    return Array(Self.allCases)
  }
  
  init(_ rawValue: RawValue) {
    self = Self(rawValue: rawValue) ?? Self.coalesce
  }
}
