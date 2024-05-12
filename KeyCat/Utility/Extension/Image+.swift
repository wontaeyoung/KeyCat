//
//  Image+.swift
//  KeyCat
//
//  Created by 원태영 on 5/12/24.
//

import SwiftUI
import Kingfisher

extension Image {
  
  static func load(with url: URL?, width: Int, height: Int) -> some View {
    
    return KFImage(url)
      .resizable()
      .placeholder { Image(.catWithKeycap1) }
      .downsampling(size: CGSize(width: width * 2, height: height * 2))
      .cacheMemoryOnly()
      .aspectRatio(contentMode: .fill)
      .frame(width: CGFloat(width), height: CGFloat(height))
  }
}
