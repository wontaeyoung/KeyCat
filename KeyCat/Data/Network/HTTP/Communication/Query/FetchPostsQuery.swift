//
//  FetchPostsQuery.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

struct FetchPostsQuery: HTTPQuery {
  let next: String
  let limit: String
  let postType: PostType
}
