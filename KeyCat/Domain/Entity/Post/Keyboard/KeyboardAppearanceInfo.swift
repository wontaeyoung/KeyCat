//
//  KeyboardAppearanceInfo.swift
//  KeyCat
//
//  Created by 원태영 on 4/13/24.
//

// MARK: - 키보드 외관
struct KeyboardAppearanceInfo {
  
  let ratio: LayoutRatio
  let design: KeyboardDesign
  let material: Material
  let size: Size
  
  var raws: [Int] {
    return [
      ratio.rawValue,
      design.rawValue,
      material.rawValue,
      size.width,
      size.height,
      size.depth,
      size.weight,
    ]
  }
  
  enum LayoutRatio: Int, SelectionExpressible {
    
    case hundred
    case ninetySix
    case eighty
    case seventyFive
    case sixtyFive
    case sixty
    case forty
    case twenty
    case other
    
    static let coalesce: LayoutRatio = .hundred
    
    var name: String {
      switch self {
        case .hundred: "100%"
        case .ninetySix: "96%"
        case .eighty: "80%"
        case .seventyFive: "75%"
        case .sixtyFive: "65%"
        case .sixty: "60%"
        case .forty: "40%"
        case .twenty: "20%"
        case .other: "기타"
      }
    }
    
    static var title: String {
      return "배열"
    }
  }

  enum KeyboardDesign: Int, SelectionExpressible {
    
    case standard
    case alice
    case split
    case oneHanded
    
    static let coalesce: KeyboardDesign = .standard
    
    var name: String {
      switch self {
        case .standard: "일반"
        case .alice: "인체공학"
        case .split: "스플릿"
        case .oneHanded: "한 손"
      }
    }
    
    static var title: String {
      return "디자인"
    }
  }

  enum Material: Int, SelectionExpressible {
    
    case plastic
    case aluminum
    case plasticAluminum
    case other
    
    static let coalesce: Material = .plastic
    
    var name: String {
      switch self {
        case .plastic: "플라스틱"
        case .aluminum: "알루미늄"
        case .plasticAluminum: "플라스틱 / 알루미늄"
        case .other: "기타"
      }
    }
    
    static var title: String {
      return "하우징"
    }
  }

  struct Size {
    
    let width: Int
    let height: Int
    let depth: Int
    let weight: Int
  }
}
