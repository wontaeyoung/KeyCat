//
//  FetchSearchHashtagQuery.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

struct SearchHashtagQuery: HTTPQuery {
  let next: String
  let limit: String
  let postType: PostType
  let hashTag: String
}
