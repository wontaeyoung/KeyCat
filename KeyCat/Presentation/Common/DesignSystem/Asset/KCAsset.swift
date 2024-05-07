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
    
    case red = "#EA4E3D"
    
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
      
      // MARK: Navigation
      case chevronBackward = "chevron.backward"
      case xmark = "xmark"
      case ellipsis = "ellipsis"
      case cart = "cart"
      
      // MARK: Label
      case exclamationmarkCircleFill = "exclamationmark.circle.fill"
      case starFill = "star.fill"
      case star = "star"
      case wonsignCircle = "wonsign.circle"
      case truckBoxBadgeClock = "truck.box.badge.clock"
      case xmarkCircleFill = "xmark.circle.fill"
      case storefrontCircle = "storefront.circle"
      
      // MARK: Button
      case cameraFill = "camera.fill"
      case checkmarkCircle = "checkmark.circle"
      case checkmarkCircleFill = "checkmark.circle.fill"
      case plusCircleFill = "plus.circle.fill"
      case pencilLine = "pencil.line"
      case trash = "trash"
      case bookmark = "bookmark"
      case bookmarkFill = "bookmark.fill"
      case cartBadgePlus = "cart.badge.plus"
      case bubbleLeftAndTextBubbleRight = "bubble.left.and.text.bubble.right"
      case square = "square"
      case checkmarkSquareFill = "checkmark.square.fill"
      
      // MARK: TabBar
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
    
    // MARK: Navigation
    static let leaveButton: UIImage? = image(.xmark)
    static let menuBarItem: UIImage? = image(.ellipsis)
    static let cart: UIImage? = image(.cart)
    static let backButton: UIImage? = image(.chevronBackward)
    
    // MARK: Label
    static let networkDisconnect: UIImage? = image(.exclamationmarkCircleFill)
    static let reviewScore: UIImage? = image(.starFill)
    static let emptyReviewScore: UIImage? = image(.star)
    static let deliveryPrice: UIImage? = image(.wonsignCircle)
    static let deliverySchedule: UIImage? = image(.truckBoxBadgeClock)
    static let seller: UIImage? = image(.storefrontCircle)
    
    // MARK: Button
    static let closeButton: UIImage? = image(.xmarkCircleFill)
    static let checkboxOff: UIImage? = image(.square)
    static let checkboxOn: UIImage? = image(.checkmarkSquareFill)
    static let createFloatingButton: UIImage? = image(.plusCircleFill)
    static let addImageButton: UIImage? = image(.cameraFill)
    static let bookmarkOff: UIImage? = image(.bookmark)
    static let bookmarkOn: UIImage? = image(.bookmarkFill)
    static let update: UIImage? = image(.pencilLine)
    static let delete: UIImage? = image(.trash)
    static let addCart: UIImage? = image(.cartBadgePlus)
    static let review: UIImage? = image(.bubbleLeftAndTextBubbleRight)
    
    // MARK: TabBar
    static let homeTab: UIImage? = image(.house)
    static let homeSelectedTab: UIImage? = image(.houseFill)
    static let shoppingTab: UIImage? = image(.bag)
    static let shoppingSelectedTab: UIImage? = image(.bagFill)
    static let profileTab: UIImage? = image(.person)
    static let profileSelectedTab: UIImage? = image(.personFill)
  }
}
