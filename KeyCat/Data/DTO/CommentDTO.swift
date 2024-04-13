//
//  CommentDTO.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

struct CommentDTO: DTO {
  let comment_id: String
  let content: String
  let createdAt: String
  let creator: UserDTO
  
  enum CodingKeys: CodingKey {
    case comment_id
    case content
    case createdAt
    case creator
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.comment_id = try container.decodeWithDefaultValue(String.self, forKey: .comment_id)
    self.content = try container.decodeWithDefaultValue(String.self, forKey: .content)
    self.createdAt = try container.decodeWithDefaultValue(String.self, forKey: .createdAt)
    self.creator = try container.decodeWithDefaultValue(UserDTO.self, forKey: .creator)
  }
  
  init(comment_id: String, content: String, createdAt: String, creator: UserDTO) {
    self.comment_id = comment_id
    self.content = content
    self.createdAt = createdAt
    self.creator = creator
  }
  
  static var defaultValue: CommentDTO {
    return CommentDTO(
      comment_id: .defaultValue,
      content: .defaultValue,
      createdAt: .defaultValue,
      creator:  .defaultValue
    )
  }
}
