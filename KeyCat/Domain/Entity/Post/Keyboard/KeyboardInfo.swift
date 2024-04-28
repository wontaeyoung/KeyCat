//
//  KeyboardInfo.swift
//  KeyCat
//
//  Created by 원태영 on 4/13/24.
//

// MARK: - 키보드 기능 정보
struct KeyboardInfo {
  
  let purpose: Purpose
  let inputMechanism: InputMechanism
  let connectionType: ConnectionType
  let powerSource: PowerSource
  let backlight: Backlight
  let mechanicalSwitch: MechanicalSwitch
  let capacitiveSwitch: CapacitiveSwitch
  let pcbType: PCBType
  
  var raws: [Int] {
    return [
      purpose.rawValue,
      inputMechanism.rawValue,
      connectionType.rawValue,
      powerSource.rawValue,
      backlight.rawValue,
      mechanicalSwitch.rawValue,
      capacitiveSwitch.rawValue,
      pcbType.rawValue,
    ]
  }
  
  enum Purpose: Int, SelectionExpressible {
    
    case office
    case gaming
    
    var name: String {
      switch self {
        case .office: "사무용"
        case .gaming: "게이밍"
      }
    }
    
    static let coalesce: Purpose = .gaming
    
    static var title: String {
      return "사용목적"
    }
  }

  enum InputMechanism: Int, SelectionExpressible {
    
    case membrane
    case mechanical
    case scissorSwitch
    case capacitiveNonContact
    case optical
    case other
    
    var name: String {
      switch self {
        case .membrane: "멤브레인"
        case .mechanical: "기계식"
        case .scissorSwitch: "펜타그래프"
        case .capacitiveNonContact: "무접점-정전용량"
        case .optical: "무접점-광축"
        case .other: "기타"
      }
    }
    
    static let coalesce: InputMechanism = .membrane
    
    static var title: String {
      return "접점방식"
    }
  }

  enum ConnectionType: Int, SelectionExpressible {
    
    case wired
    case wireless
    case bluetooth
    
    var name: String {
      switch self {
        case .wired: "유선"
        case .wireless: "무선 2.4"
        case .bluetooth: "블루투스"
      }
    }
    
    static let coalesce: ConnectionType = .wired
    
    static var title: String {
      return "연결방식"
    }
  }

  enum PowerSource: Int, SelectionExpressible {
    
    case powerCord
    case battery
    case batteryCell
    
    var name: String {
      switch self {
        case .powerCord: "연결"
        case .battery: "배터리"
        case .batteryCell: "건전지"
      }
    }
    
    static let coalesce: PowerSource = .powerCord
    
    static var title: String {
      return "전원"
    }
  }

  enum Backlight: Int, SelectionExpressible {
    
    case noBacklight
    case withBacklight
    
    var name: String {
      switch self {
        case .noBacklight: "없음"
        case .withBacklight: "있음"
      }
    }
    
    static let coalesce: Backlight = .noBacklight
    
    static var title: String {
      return "백라이트"
    }
  }
  
  enum MechanicalSwitch: Int, SelectionExpressible {
    
    case none
    case clicky
    case tactile
    case linear
    case silentTactile
    case silentLinear
    
    var name: String {
      switch self {
        case .none: "해당없음"
        case .clicky: "클릭키"
        case .tactile: "택타일"
        case .linear: "리니어"
        case .silentTactile: "저소음 택타일"
        case .silentLinear: "저소음 리니어"
      }
    }
    
    static let coalesce: MechanicalSwitch = .none
    
    static var title: String {
      return "스위치"
    }
  }

  enum CapacitiveSwitch: Int, SelectionExpressible {
    
    case none
    case noppoo
    case topre
    
    var name: String {
      switch self {
        case .none: "해당없음"
        case .noppoo: "노뿌"
        case .topre: "토프레"
      }
    }
    
    static let coalesce: CapacitiveSwitch = .none
    
    static var title: String {
      return "스위치"
    }
  }
  
  enum PCBType: Int, SelectionExpressible {
    
    case none
    case soldering
    case hotSwap
    
    var name: String {
      switch self {
        case .none: "해당없음"
        case .soldering: "솔더링"
        case .hotSwap: "핫스왑"
      }
    }
    
    static let coalesce: PCBType = .none
    
    static var title: String {
      return "기판"
    }
  }
}
