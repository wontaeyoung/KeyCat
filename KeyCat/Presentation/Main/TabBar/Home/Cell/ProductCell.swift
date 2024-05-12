//
//  ProductCell.swift
//  KeyCat
//
//  Created by 원태영 on 5/13/24.
//

import SwiftUI

struct ProductCell: View {
  
  let post: CommercialPost
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Image.load(with: post.mainImageURL, width: 150, height: 150)
        .clipped()
        .cornerRadius(10)
        .overlay {
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color.lightGrayBackground, lineWidth: 1)
        }
      
      Text(post.title)
        .font(.medium(size: 14))
        .lineLimit(2)
        .lineSpacing(10)
        .frame(alignment: .top)
      
      HStack(spacing: 5) {
        Text(post.price.discountRatio.description + "%")
        
        Text(post.price.regularPrice.formatted())
          .strikethrough()
      }
      .font(.medium(size: 12))
      .foregroundStyle(post.price.discountRatio == .zero ? .clear : .lightGrayForeground)
      
      Text(post.price.discountPrice.formatted() + "원")
        .font(.medium(size: 12))
      
      HStack(spacing: 0) {
        Image(uiImage: (KCAsset.Symbol.reviewScore ?? UIImage()).withRenderingMode(.alwaysTemplate))
          .foregroundStyle(Color.brand)
          .padding(.trailing, 5)
        
        Text(post.reviews.isEmpty ? "-" : post.reviews.averageScore.rounded)
          .font(.medium(size: 12))
          .padding(.trailing, 2)
        
        Text("(\(post.reviews.count))")
          .font(.medium(size: 12))
          .foregroundStyle(.gray)
      }
    }
    .frame(maxWidth: 150)
  }
}
