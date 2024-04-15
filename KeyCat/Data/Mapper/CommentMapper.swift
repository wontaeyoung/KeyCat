//
//  CommentMapper.swift
//  KeyCat
//
//  Created by 원태영 on 4/15/24.
//

struct CommentMapper: Mapper {
  
  private let userMapper = UserMapper()
  
  func toEntity(_ dto: CommentDTO) -> CommercialReview {
    let contentDTO: CommentContentDTO = try! JsonCoder.shared.decodeString(from: dto.content)
    
    return CommercialReview(
      reviewID: dto.comment_id,
      content: contentDTO.content,
      rating: .init(contentDTO.rating),
      createdAt: toDate(from: dto.createdAt),
      creator: userMapper.toEntity(dto.creator)
    )
  }
}
