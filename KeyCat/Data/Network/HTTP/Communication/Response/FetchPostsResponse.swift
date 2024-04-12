//
//  FetchPostsResponse.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

struct FetchPostsResponse: HTTPResponse {
  let data: [PostDTO]
  let next_cursor: String
}
