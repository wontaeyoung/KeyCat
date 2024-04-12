//
//  PostDTO.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

/// 게시글 생성
/// 게시글 조회의 프로퍼티
/// 특정 게시글 조회
/// 게시글 수정
struct PostDTO: DTO {
  let post_id: String
  let product_id: String?
  let title: String?
  let content: String?
  let content1: String?
  let content2: String?
  let content3: String?
  let content4: String?
  let content5: String?
  let createdAt: String
  let creator: UserDTO
  let files: [String]
  let likes: [String]
  let likes2: [String]
  let hashTags: [String]
  let comments: [CommentDTO]
  
  static var defaultValue: PostDTO {
    return PostDTO(
      post_id: .defaultValue,
      product_id: .defaultValue,
      title: .defaultValue,
      content: .defaultValue,
      content1: .defaultValue,
      content2: .defaultValue,
      content3: .defaultValue,
      content4: .defaultValue,
      content5: .defaultValue,
      createdAt: .defaultValue,
      creator: .defaultValue,
      files: .defaultValue,
      likes: .defaultValue,
      likes2: .defaultValue,
      hashTags: .defaultValue,
      comments: .defaultValue
    )
  }
}
