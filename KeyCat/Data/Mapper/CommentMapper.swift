//
//  CommentMapper.swift
//  KeyCat
//
//  Created by 원태영 on 4/15/24.
//

struct CommentMapper: Mapper {
  
  private let userMapper = UserMapper()
  
  func toEntity(_ dto: CommentDTO) -> CommercialReview? {
    
    guard let contentDTO: CommentContentDTO = try? JsonCoder.shared.decodeString(from: dto.content) else { return nil }
    
    return CommercialReview(
      reviewID: dto.comment_id,
      content: contentDTO.content,
      rating: .init(contentDTO.rating),
      createdAt: toDate(from: dto.createdAt),
      creator: userMapper.toEntity(dto.creator)
    )
  }
  
  func toEntity(_ dtos: [CommentDTO]) -> [CommercialReview] {
    return dtos.compactMap { toEntity($0) }
  }
  
  func toDTO(_ entity: CommercialReview) -> CommentDTO? {
    
    let contentDTO: CommentContentDTO = CommentContentDTO(content: entity.content, rating: entity.rating.rawValue)
    guard let commentContentString = try? JsonCoder.shared.encodeString(from: contentDTO) else { return nil }
    
    return CommentDTO(
      comment_id: entity.reviewID,
      content: commentContentString,
      createdAt: entity.createdAt.toISOString,
      creator: userMapper.toDTO(entity.creator)
    )
  }
  
  func toDTO(_ entities: [CommercialReview]) -> [CommentDTO] {
    return entities.compactMap { toDTO($0) }
  }
  
  func toRequest(_ entity: CommercialReview) -> CommentRequest? {
    
    let contentDTO: CommentContentDTO = CommentContentDTO(content: entity.content, rating: entity.rating.rawValue)
    guard let commentContentString = try? JsonCoder.shared.encodeString(from: contentDTO) else { return nil }
    
    return CommentRequest(content: commentContentString)
  }
}
