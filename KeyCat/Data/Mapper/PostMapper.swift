//
//  PostMapper.swift
//  KeyCat
//
//  Created by 원태영 on 4/14/24.
//

import Foundation

struct PostMapper: Mapper {
  
  private let userMapper = UserMapper()
  private let commentMapper = CommentMapper()
  
  func toEntity(_ dto: PostDTO) -> CommercialPost? {
    
    guard 
      let keyboard = mapKeyboard(from: dto),
      let price = mapCommercialPrice(from: dto),
      let deliveryInfo = mapDeliveryInfo(from: dto)
    else {
      return nil
    }
    
    return CommercialPost(
      postID: dto.post_id,
      postType: PostType(productID: dto.product_id),
      title: dto.title,
      content: dto.content,
      keyboard: keyboard,
      price: price,
      delivery: deliveryInfo,
      createdAt: toDate(from: dto.createdAt),
      creator: userMapper.toEntity(dto.creator),
      files: dto.files,
      likes: dto.likes,
      shoppingCarts: dto.likes2,
      hashTags: dto.hashTags,
      reviews: commentMapper.toEntity(dto.comments)
    )
  }
  
  func toEntity(_ dtos: [PostDTO]) -> [CommercialPost] {
    return dtos
      .compactMap { toEntity($0) }
  }
  
  func toDTO(_ entity: CommercialPost) -> PostDTO? {
    
    let keyboardDTO = mapKeyboardDTO(from: entity.keyboard)
    let commercialPriceDTO = mapCommercialPriceDTO(from: entity.price)
    let deliveryInfoDTO = mapDeliveryInfoDTO(from: entity.delivery)
    
    guard
      let keyboardString = try? JsonCoder.shared.encodeString(from: keyboardDTO),
      let commercialPriceString = try? JsonCoder.shared.encodeString(from: commercialPriceDTO),
      let deliveryInfoString = try? JsonCoder.shared.encodeString(from: deliveryInfoDTO)
    else {
      return nil
    }
    
    return PostDTO(
      post_id: entity.postID,
      product_id: entity.postType.productID,
      title: entity.title,
      content: entity.content,
      content1: keyboardString,
      content2: commercialPriceString,
      content3: deliveryInfoString,
      content4: "",
      content5: "",
      createdAt: entity.createdAt.toISOString,
      creator: userMapper.toDTO(entity.creator),
      files: entity.files,
      likes: entity.likes,
      likes2: [],
      hashTags: entity.hashTags,
      comments: commentMapper.toDTO(entity.reviews)
    )
  }
  
  func toRequest(_ entity: CommercialPost, isUpdateImages: Bool) -> PostRequest? {
    
    let keyboardDTO = mapKeyboardDTO(from: entity.keyboard)
    let commercialPriceDTO = mapCommercialPriceDTO(from: entity.price)
    let deliveryInfoDTO = mapDeliveryInfoDTO(from: entity.delivery)
    
    guard
      let keyboardString = try? JsonCoder.shared.encodeString(from: keyboardDTO),
      let commercialPriceString = try? JsonCoder.shared.encodeString(from: commercialPriceDTO),
      let deliveryInfoString = try? JsonCoder.shared.encodeString(from: deliveryInfoDTO)
    else {
      return nil
    }
    
    return PostRequest(
      title: entity.title,
      content: entity.content,
      content1: keyboardString,
      content2: commercialPriceString,
      content3: deliveryInfoString,
      product_id: entity.postType.productID,
      files: isUpdateImages ? entity.files : nil
    )
  }
}

extension PostMapper {
  private func mapKeyboard(from dto: PostDTO) -> Keyboard? {
    
    guard
      let keyboardDTO: KeyboardDTO = try? JsonCoder.shared.decodeString(from: dto.content1),
      keyboardDTO.keyboardInfo.count == BusinessValue.OptionLength.keyboardInfo,
      keyboardDTO.keycapInfo.count == BusinessValue.OptionLength.keycapInfo,
      keyboardDTO.appearanceInfo.count == BusinessValue.OptionLength.keyboardAppearance
    else {
      return nil
    }
    
    let keyboardInfo: KeyboardInfo = KeyboardInfo(
      purpose: .init(keyboardDTO.keyboardInfo[0]),
      inputMechanism: .init(keyboardDTO.keyboardInfo[1]),
      connectionType: .init(keyboardDTO.keyboardInfo[2]),
      powerSource: .init(keyboardDTO.keyboardInfo[3]),
      backlight: .init(keyboardDTO.keyboardInfo[4]),
      pcbType: .init(keyboardDTO.keyboardInfo[5]), 
      mechanicalSwitch: .init(keyboardDTO.keyboardInfo[6]),
      capacitiveSwitch: .init(keyboardDTO.keyboardInfo[7])
    )
    
    let keycapInfo: KeycapInfo = KeycapInfo(
      profile: .init(keyboardDTO.keycapInfo[0]),
      direction: .init(keyboardDTO.keycapInfo[1]),
      process: .init(keyboardDTO.keycapInfo[2]),
      language: .init(keyboardDTO.keycapInfo[3])
    )
    
    let appearanceInfo: KeyboardAppearanceInfo = KeyboardAppearanceInfo(
      ratio: .init(keyboardDTO.appearanceInfo[0]),
      design: .init(keyboardDTO.appearanceInfo[1]),
      material: .init(keyboardDTO.appearanceInfo[2]),
      size: .init(
        width: .init(keyboardDTO.appearanceInfo[3]),
        height: .init(keyboardDTO.appearanceInfo[4]),
        depth: .init(keyboardDTO.appearanceInfo[5]),
        weight: .init(keyboardDTO.appearanceInfo[6])
      )
    )
    
    return Keyboard(
      keyboardInfo: keyboardInfo,
      keycapInfo: keycapInfo,
      keyboardAppearanceInfo: appearanceInfo
    )
  }
  
  private func mapKeyboardDTO(from entity: Keyboard) -> KeyboardDTO {
    return KeyboardDTO(
      keyboardInfo: entity.keyboardInfo.raws,
      keycapInfo: entity.keycapInfo.raws,
      appearanceInfo: entity.keyboardAppearanceInfo.raws
    )
  }
  
  private func mapCommercialPrice(from dto: PostDTO) -> CommercialPrice? {
    
    guard let priceDTO: CommercialPriceDTO = try? JsonCoder.shared.decodeString(from: dto.content2) else {
      return nil
    }
    
    return CommercialPrice(
      regularPrice: priceDTO.regularPrice,
      couponPrice: priceDTO.couponPrice,
      discountPrice: priceDTO.discountPrice,
      discountExpiryDate: priceDTO.discountExpiryDate.isEmpty
      ? nil
      : DateManager.shared.isoStringtoDate(with: priceDTO.discountExpiryDate)
    )
  }
  
  private func mapCommercialPriceDTO(from entity: CommercialPrice) -> CommercialPriceDTO {
    return CommercialPriceDTO(
      regularPrice: entity.regularPrice,
      couponPrice: entity.couponPrice,
      discountPrice: entity.discountPrice,
      discountExpiryDate: DateManager.shared.dateToIsoString(with: entity.discountExpiryDate)
    )
  }
  
  private func mapDeliveryInfo(from dto: PostDTO) -> DeliveryInfo? {
    
    guard let deliveryInfoDTO: DeliveryInfoDTO = try? JsonCoder.shared.decodeString(from: dto.content3) else {
      return nil
    }
    
    return DeliveryInfo(
      price: .init(deliveryInfoDTO.price),
      schedule: .init(deliveryInfoDTO.schedule)
    )
  }
  
  private func mapDeliveryInfoDTO(from entity: DeliveryInfo) -> DeliveryInfoDTO {
    return DeliveryInfoDTO(
      price: entity.price.rawValue,
      schedule: entity.schedule.rawValue
    )
  }
}
