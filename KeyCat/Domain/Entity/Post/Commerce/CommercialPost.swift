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
  let likes: [UserID]
  let shoppingCarts: [UserID]
  let hashTags: [Hashtag]
  let reviews: [CommercialReview]
  
  var productImagesURL: [URL?] {
    return files.map { URL(string: $0) }
  }
}
