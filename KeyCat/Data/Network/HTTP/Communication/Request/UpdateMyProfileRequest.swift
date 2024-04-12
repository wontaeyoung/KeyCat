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
}
