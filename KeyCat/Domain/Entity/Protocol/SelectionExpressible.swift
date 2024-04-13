//
//  SelectionExpressible.swift
//  KeyCat
//
//  Created by 원태영 on 4/13/24.
//

protocol SelectionExpressible: CaseIterable, RawRepresentable where Self.RawValue == Int {
  var name: String { get }
  static var title: String { get }
  static var selection: [Self] { get }
}

extension SelectionExpressible {
  static var selection: [Self] {
    return Array(Self.allCases)
  }
}
