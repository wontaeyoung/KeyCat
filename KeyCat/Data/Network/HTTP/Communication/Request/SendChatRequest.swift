//
//  SendChatRequest.swift
//  KeyCat
//
//  Created by 원태영 on 5/20/24.
//

struct SendChatRequest: HTTPRequestBody {
  
  let content: String
  let files: [Entity.URLString]
}
