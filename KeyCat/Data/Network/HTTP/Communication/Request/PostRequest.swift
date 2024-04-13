//
//  PostRequest.swift
//  KeyCat
//
//  Created by 원태영 on 4/13/24.
//

struct PostRequest: HTTPRequestBody {
  let title: String?
  let content: String?
  let content1: String?
  let content2: String?
  let content3: String?
  let content4: String?
  let content5: String?
  let product_id: String?
  let files: [String]?
}