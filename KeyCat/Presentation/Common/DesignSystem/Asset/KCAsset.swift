//
//  KCAsset.swift
//  KeyCat
//
//  Created by 원태영 on 4/10/24.
//

import UIKit

enum KCAsset {
  
  enum Color: String {
    
    case brand = "#7E63FF"
    case primary = "#A896FF"
    case secondary = "#C1CFFF"
    case lightGrayBackground = "#F2F2F6"
    case lightGrayForeground = "#BCBCBC"
    case darkGray = "#686868"
    case black = "#000000"
    case white = "#FFFFFF"
    case pastelRed = "#E8A2A2"
    case pastelBlue = "#A0C3D2"
    case pastelGreen = "#A8D1D1"
    
    var color: UIColor {
      return UIColor(hex: self.rawValue)
    }
    
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
    
    case medium(size: CGFloat)
    case bold(size: CGFloat)
    
    var font: UIFont {
      switch self {
        case .medium(let size):
          return Self.font(.medium, size: size)
          
        case .bold(let size):
          return Self.font(.bold, size: size)
      }
    }
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
      case wonsignCircle = "wonsign.circle"
      case truckBoxBadgeClock = "truck.box.badge.clock"
      case ellipsis = "ellipsis"
      case pencilLine = "pencil.line"
      case trash = "trash"
      
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
    static let deliveryPrice: UIImage? = image(.wonsignCircle)
    static let deliverySchedule: UIImage? = image(.truckBoxBadgeClock)
    
    static let menuBarItem: UIImage? = image(.ellipsis)
    static let update: UIImage? = image(.pencilLine)
    static let delete: UIImage? = image(.trash)
    
    static let homeTab: UIImage? = image(.house)
    static let homeSelectedTab: UIImage? = image(.houseFill)
    static let shoppingTab: UIImage? = image(.bag)
    static let shoppingSelectedTab: UIImage? = image(.bagFill)
    static let profileTab: UIImage? = image(.person)
    static let profileSelectedTab: UIImage? = image(.personFill)
  }
}
