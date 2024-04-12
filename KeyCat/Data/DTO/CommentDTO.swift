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
  
  static var defaultValue: CommentDTO {
    return CommentDTO(
      comment_id: .defaultValue,
      content: .defaultValue,
      createdAt: .defaultValue,
      creator:  .defaultValue
    )
  }
}
