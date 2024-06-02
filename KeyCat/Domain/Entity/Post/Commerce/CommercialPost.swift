//
//  CommercialPost.swift
//  KeyCat
//
//  Created by 원태영 on 4/14/24.
//

import Foundation

struct CommercialPost: Entity {
  
  let postID: PostID
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
  var shoppingCarts: [UserID]
  let hashTags: [Hashtag]
  var reviews: [CommercialReview]
  var buyers: [UserID]
  
  var mainImageURL: URL? {
    return productImagesURL
      .compactMap { $0 }
      .first
  }
  
  var productImagesURL: [URL?] {
    return files.map { URL(string: $0) }
  }
  
  var isBookmarked: Bool {
    return bookmarks.contains(UserInfoService.userID)
  }
  
  var isAddedInCart: Bool {
    return shoppingCarts.contains(UserInfoService.userID)
  }
  
  var isCreatedByMe: Bool {
    return creator.userID == UserInfoService.userID
  }
}
