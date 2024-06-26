//
//  InputInformation.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

enum InputInformation {
  
  case email
  case password
  case passwordCheck
  case nickname
  case businessNumber
  case regularPrice
  case discountPrice
  case coupon
  
  var title: String {
    switch self {
      case .email: "이메일"
      case .password: "비밀번호"
      case .passwordCheck: "비밀번호 확인"
      case .nickname: "닉네임"
      case .businessNumber: "사업자 번호"
      case .regularPrice: "가격(₩)"
      case .discountPrice: "할인가(₩)"
      case .coupon: "쿠폰(₩)"
    }
  }
  
  func valitationInfoText(isValid: Bool) -> String {
    switch self {
      case .email:
        return isValid
        ? "사용 가능한 이메일 형식입니다."
        : "이메일 형식에 맞춰서 입력해주세요."
        
      case .password:
        return isValid
        ? "사용 가능한 비밀번호입니다."
        : "비밀번호는 4 ~ 12자 사이에서 !, @, #, $ 중 하나 이상을 포함해주세요."
        
      case .passwordCheck:
        return isValid
        ? "비밀번호가 일치합니다."
        : "비밀번호가 일치하지 않습니다."
        
      case .nickname:
        return isValid
        ? "사용 가능한 닉네임입니다."
        : "닉네임은 2 ~ 6자 사이로 특수문자 없이 입력해주세요."
        
      case .businessNumber:
        return isValid
        ? ""
        : "10자리의 숫자로 입력해주세요."
        
      case .regularPrice:
        return isValid
        ? ""
        : "숫자만 입력해주세요."
        
      case .discountPrice:
        return isValid
        ? ""
        : "정가보다 큰 금액은 입력할 수 없어요."
        
      case .coupon:
        return isValid
        ? ""
        : "쿠폰은 1,000원 단위로만 입력 가능해요."
    }
  }
  
  var pattern: String {
    switch self {
      case .email: #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
      case .password: #"^(?=.*[!@#$])[a-zA-Z0-9!@#$]{4,12}$"#
      case .passwordCheck: ""
      case .nickname: #"^[\w가-힣]{2,6}$"#
      case .businessNumber: #"^\d{10}$"#
      case .regularPrice: #"^[0-9]+$"#
      case .discountPrice: ""
      case .coupon: ""
    }
  }
}
