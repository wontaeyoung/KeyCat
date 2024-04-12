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
}
