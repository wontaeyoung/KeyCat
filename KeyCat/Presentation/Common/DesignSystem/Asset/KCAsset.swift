//
//  KCAsset.swift
//  KeyCat
//
//  Created by 원태영 on 4/10/24.
//

import UIKit

enum KCAsset {
  
  enum Color {
    static let brand: UIColor = .init(hex: "#7E63FF")
    static let primary: UIColor = .init(hex: "#A896FF")
    static let secondary: UIColor = .init(hex: "#C1CFFF")
    static let lightGrayBackground: UIColor = .init(hex: "#F2F2F6")
    static let lightGrayForeground: UIColor = .init(hex: "#BCBCBC")
    static let darkGray: UIColor = .init(hex: "#686868")
    static let black: UIColor = .init(hex: "000000")
    static let white: UIColor = .init(hex: "FFFFFF")
    static let pastelRed: UIColor = .init(hex: "#E8A2A2")
    static let pastelBlue: UIColor = .init(hex: "#A0C3D2")
    static let pastelGreen: UIColor = .init(hex: "#A8D1D1")
    
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
    
    static let signField: UIFont = font(.medium, size: 19)
    static let productField: UIFont = font(.medium, size: 17)
    static let inputFieldPlaceholder: UIFont = font(.medium, size: 13)
    static let appLogoLabel: UIFont = font(.bold, size: 50)
    static let title: UIFont = font(.bold, size: 24)
    static let sectionTitle: UIFont = font(.bold, size: 20)
    static let standardTitle: UIFont = font(.medium, size: 16)
    static let buttonTitle: UIFont = font(.bold, size: 19)
    static let floatingButtonTitle: UIFont = font(.bold, size: 40)
    static let captionLabel: UIFont = font(.medium, size: 15)
    static let contentText: UIFont = font(.medium, size: 15)
    static let mini: UIFont = font(.medium, size: 13)
    static let tag: UIFont = font(.bold, size: 12)
    
    static let toastTitle: UIFont = font(.bold, size: 17)
    static let toastMessage: UIFont = font(.bold, size: 15)
  }
  
  enum Symbol {
    
    private enum SF: String {
      
      case xmark = "xmark"
      case xmarkCircleFill = "xmark.circle.fill"
      case checkmarkCircle = "checkmark.circle"
      case checkmarkCircleFill = "checkmark.circle.fill"
      case plusCircleFill = "plus.circle.fill"
      case cameraFill = "camera.fill"
      case exclamationmarkCircleFill = "exclamationmark.circle.fill"
      case starFill = "star.fill"
      case bookmark = "bookmark"
      case bookmarkFill = "bookmark.fill"
      
      case house = "house"
      case houseFill = "house.fill"
      case bag = "bag"
      case bagFill = "bag.fill"
      case person = "person"
      case personFill = "person.fill"
    }
    
    private static func image(_ sf: SF) -> UIImage? {
      return UIImage(systemName: sf.rawValue)
    }
    
    static let leaveButton: UIImage? = image(.xmark)
    static let closeButton: UIImage? = image(.xmarkCircleFill)
    static let checkboxOff: UIImage? = image(.checkmarkCircle)
    static let checkboxOn: UIImage? = image(.checkmarkCircleFill)
    static let createFloatingButton: UIImage? = image(.plusCircleFill)
    static let addImageButton: UIImage? = image(.cameraFill)
    static let networkDisconnect: UIImage? = image(.exclamationmarkCircleFill)
    static let review: UIImage? = image(.starFill)
    static let bookmarkOff: UIImage? = image(.bookmark)
    static let bookmarkOn: UIImage? = image(.bookmarkFill)
    
    static let homeTab: UIImage? = image(.house)
    static let homeSelectedTab: UIImage? = image(.houseFill)
    static let shoppingTab: UIImage? = image(.bag)
    static let shoppingSelectedTab: UIImage? = image(.bagFill)
    static let profileTab: UIImage? = image(.person)
    static let profileSelectedTab: UIImage? = image(.personFill)
  }
}
