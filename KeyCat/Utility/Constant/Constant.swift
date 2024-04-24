//
//  Constant.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

enum Constant {
  
  enum Label {
    
    static let appName: String = "KeyCat"
    static let signUpInfo: String = "아직 계정이 없으신가요?"
    
    static let inputSellerAuthority: String = "판매자 권한이 필요하신가요?"
    static let inputBusinessInfo: String = "사업자 정보를 인증해주세요!"
    static let updateSellerAuthorityAvailable: String = "판매자 인증은 프로필에서 다시 할 수 있어요."
    
    static let inputEmailInfo: String = "이메일을 알려주세요!"
    static let duplicatedEmailInfo: String = "이미 가입된 이메일이에요."
    static let avaliableEmailInfo: String = "사용 가능한 이메일이에요."
    
    static let inputPasswordInfo: String = "안전하게 사용할 수 있는 비밀번호를 알려주세요!"
    
    static let inputProfileInfo: String = "프로필을 설정해주세요!"
    static let updateProfileImageAvailable: String = "프로필 이미지는 프로필에서 다시 설정할 수 있어요."
  }
  
  enum Button {
    
    static let signIn: String = "로그인"
    static let signUp: String = "회원가입"
    static let duplicateCheck: String = "중복 확인"
    static let duplicateCheckInfo: String = "중복 확인이 필요해요!"
    static let next: String = "다음으로"
    static let sellerAuthority: String = "네, 필요해요"
    static let onlyCustomerAuthority: String = "아니요, 필요하지 않아요"
    static let businessInfoAuthentication: String = "사업자 인증"
  }
  
  enum FileExtension {
    
    static let jpg: String = "jpg"
    static let jpeg: String = "jpeg"
    static let png: String = "png"
  }
}
