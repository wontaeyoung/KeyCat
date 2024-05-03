//
//  CommercialPost.swift
//  KeyCat
//
//  Created by 원태영 on 4/14/24.
//

import Foundation

struct CommercialPost: Entity {
  
  let postID: String
  let postType: PostType
  let title: String
  let content: String
  let keyboard: Keyboard
  let price: CommercialPrice
  let delivery: DeliveryInfo
  let createdAt: Date
  let creator: User
  var files: [URLString]
  let bookmarks: [UserID]
  let shoppingCarts: [UserID]
  let hashTags: [Hashtag]
  var reviews: [CommercialReview]
  
  var productImagesURL: [URL?] {
    return files.map { URL(string: APIKey.baseURL + "/" + $0) }
  }
  
  var isBookmarked: Bool {
    return bookmarks.contains(UserInfoService.userID)
  }
  
  var isCreatedByMe: Bool {
    return creator.userID == UserInfoService.userID
  }
}
