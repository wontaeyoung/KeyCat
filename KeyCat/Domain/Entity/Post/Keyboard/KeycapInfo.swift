//
//  KeycapInfo.swift
//  KeyCat
//
//  Created by 원태영 on 4/13/24.
//

// MARK: - 키캡 정보
struct KeycapInfo {
  let profile: KeycapProfile
  let direction: PrintingDirection
  let process: PrintingProcess
  let language: PrintingLanguage
  
  var raws: [Int] {
    return [
      profile.rawValue,
      direction.rawValue,
      process.rawValue,
      language.rawValue,
    ]
  }
  
  enum KeycapProfile: Int, SelectionExpressible {
    case cherry
    case oem
    case sa
    case ksa
    case osa
    case dsa
    case xda
    case mda
    
    var name: String {
      switch self {
        case .cherry: "체리"
        case .oem: "OEM"
        case .sa: "SA"
        case .ksa: "KSA"
        case .osa: "OSA"
        case .dsa: "DSA"
        case .xda: "XDA"
        case .mda: "MDA"
      }
    }
    
    static var title: String {
      return "키캡 프로파일"
    }
  }

  enum PrintingDirection: Int, SelectionExpressible {
    case top
    case side
    case blank
    
    var name: String {
      switch self {
        case .top: "정각"
        case .side: "측각"
        case .blank: "무각"
      }
    }
    
    static var title: String {
      return "각인 방향"
    }
  }

  enum PrintingProcess: Int, SelectionExpressible {
    case laser
    case dyeSublimation
    case doubleShot
    
    var name: String {
      switch self {
        case .laser: "레이저"
        case .dyeSublimation: "염료승화"
        case .doubleShot: "이중사출"
      }
    }
    
    static var title: String {
      return "각인 방법"
    }
  }

  enum PrintingLanguage: Int, SelectionExpressible {
    case koreanEnglish
    case english
    case japanese
    case chinese
    
    var name: String {
      switch self {
        case .koreanEnglish: "한영"
        case .english: "영어"
        case .japanese: "일어"
        case .chinese: "중국어"
      }
    }
    
    static var title: String {
      return "각인 언어"
    }
  }
}
