//
//  UpdateMyProfileRequest.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

import Foundation

struct UpdateMyProfileRequest: HTTPRequestBody {
  let nick: String?
  let phoneNum: String?
  let birthDay: String?
  let profile: Data?
  
  init(nick: String?, phoneNum: String?, birthDay: String?, profile: Data?) {
    self.nick = nick
    self.phoneNum = phoneNum
    self.birthDay = birthDay
    self.profile = profile
  }
  
  init(profile: Data?) {
    self.nick = nil
    self.phoneNum = nil
    self.birthDay = nil
    self.profile = profile
  }
  
  init(phoneNum: String) {
    self.nick = nil
    self.phoneNum = phoneNum
    self.birthDay = nil
    self.profile = nil
  }
}
