//
//  Color+.swift
//  KeyCat
//
//  Created by 원태영 on 5/11/24.
//

import SwiftUI

extension Color {
  init(hex: Int, opacity: Double = 1.0) {
    let red = Double((hex >> 16) & 0xff) / 255
    let green = Double((hex >> 8) & 0xff) / 255
    let blue = Double((hex >> 0) & 0xff) / 255
    
    self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
  }
  
  init(_ hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}

extension Color {
  
  static let brand = Color("#7E63FF")
  static let primary = Color("#A896FF")
  static let secondary = Color("#C1CFFF")
  static let lightGrayBackground = Color("#F2F2F6")
  static let lightGrayForeground = Color("#BCBCBC")
  static let darkGray = Color("#686868")
  static let black = Color("#000000")
  static let white = Color("#FFFFFF")
  static let pastelRed = Color("#E8A2A2")
  static let pastelBlue = Color("#A0C3D2")
  static let pastelGreen = Color("#A8D1D1")
}
