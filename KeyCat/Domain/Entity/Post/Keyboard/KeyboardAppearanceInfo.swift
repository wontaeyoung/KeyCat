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
    case twenty
    case forty
    case sixty
    case sixtyFive
    case seventyFive
    case eighty
    case ninetySix
    case hundred
    case other
    
    var name: String {
      switch self {
        case .twenty: "20%"
        case .forty: "40%"
        case .sixty: "60%"
        case .sixtyFive: "65%"
        case .seventyFive: "75%"
        case .eighty: "80%"
        case .ninetySix: "96%"
        case .hundred: "100%"
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
    
    var name: String {
      switch self {
        case .plastic: "플라스틱"
        case .aluminum: "알루미늄"
        case .plasticAluminum: "플라스틱/알루미늄"
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
