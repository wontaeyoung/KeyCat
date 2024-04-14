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
  let product_id: String
  let title: String
  let content: String
  let content1: String // 키보드 정보
  let content2: String // [정가, 쿠폰가, 할인가, 할인종료일]
  let content3: String // [무료배송, 도착정보]
  let content4: String
  let content5: String
  let createdAt: String
  let creator: UserDTO
  let files: [String]
  let likes: [String]
  let likes2: [String]
  let hashTags: [String]
  let comments: [CommentDTO]
  
  enum CodingKeys: CodingKey {
    case post_id
    case product_id
    case title
    case content
    case content1
    case content2
    case content3
    case content4
    case content5
    case createdAt
    case creator
    case files
    case likes
    case likes2
    case hashTags
    case comments
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.post_id = try container.decode(String.self, forKey: .post_id)
    self.product_id = try container.decodeWithDefaultValue(String.self, forKey: .product_id)
    self.title = try container.decodeWithDefaultValue(String.self, forKey: .title)
    self.content = try container.decodeWithDefaultValue(String.self, forKey: .content)
    self.content1 = try container.decodeWithDefaultValue(String.self, forKey: .content1)
    self.content2 = try container.decodeWithDefaultValue(String.self, forKey: .content2)
    self.content3 = try container.decodeWithDefaultValue(String.self, forKey: .content3)
    self.content4 = try container.decodeWithDefaultValue(String.self, forKey: .content4)
    self.content5 = try container.decodeWithDefaultValue(String.self, forKey: .content5)
    self.createdAt = try container.decode(String.self, forKey: .createdAt)
    self.creator = try container.decode(UserDTO.self, forKey: .creator)
    self.files = try container.decode([String].self, forKey: .files)
    self.likes = try container.decode([String].self, forKey: .likes)
    self.likes2 = try container.decode([String].self, forKey: .likes2)
    self.hashTags = try container.decode([String].self, forKey: .hashTags)
    self.comments = try container.decode([CommentDTO].self, forKey: .comments)
  }
}
