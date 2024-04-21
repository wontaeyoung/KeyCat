//
//  KCAsset.swift
//  KeyCat
//
//  Created by 원태영 on 4/10/24.
//

import UIKit

enum KCAsset {
  
  enum Color {
    static let brand: UIColor = .init(hex: "#A896FF")
    static let primary: UIColor = .init(hex: "#C2A3C6")
    static let secondary: UIColor = .init(hex: "#F8E2F4")
    static let lightGrayBackground: UIColor = .init(hex: "#F2F2F6")
    static let lightGrayForeground: UIColor = .init(hex: "#BCBCBC")
    static let darkGray: UIColor = .init(hex: "#686868")
    static let black: UIColor = .init(hex: "000000")
    static let white: UIColor = .init(hex: "FFFFFF")
    
    static let background: UIColor = .background
    static let label: UIColor = .label
    static let correct: UIColor = .systemGreen
    static let incorrect: UIColor = .systemRed
  }
  
  enum Font {
    private enum Name: String {
      case bold = "GmarketSansBold"
      case medium = "GmarketSansMedium"
      
      var name: String {
        return self.rawValue
      }
    }
    
    private static func font(_ fontName: Name, size: CGFloat) -> UIFont {
      let coalesceWeight: UIFont.Weight
      
      switch fontName {
        case .bold:
          coalesceWeight = .bold
        case .medium:
          coalesceWeight = .medium
      }
      
      return UIFont(name: fontName.name, size: size) ?? .systemFont(ofSize: size, weight: coalesceWeight)
    }
    
    static let inputField: UIFont = font(.medium, size: 19)
    static let inputFieldInfoLabel: UIFont = font(.medium, size: 13)
    static let appLogoLabel: UIFont = font(.bold, size: 50)
    static let mainInfoTitle: UIFont = font(.bold, size: 24)
    static let buttonTitle: UIFont = font(.bold, size: 19)
    static let captionLabel: UIFont = font(.medium, size: 15)
    
    static let toastTitle: UIFont = font(.bold, size: 17)
    static let toastMessage: UIFont = font(.bold, size: 15)
  }
  
  enum Symbol {
    
    private enum SF: String {
      case house = "house"
    }
    
    private static func image(_ sf: SF) -> UIImage? {
      return UIImage(systemName: sf.rawValue)
    }
  }
}
