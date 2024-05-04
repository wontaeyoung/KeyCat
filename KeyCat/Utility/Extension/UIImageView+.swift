//
//  UIImageView+.swift
//  KeyCat
//
//  Created by 원태영 on 5/2/24.
//

import UIKit
import Kingfisher

extension UIImageView {
  func load(with url: URL?) {
    
    let size = self.bounds.size
    let processor = DownsamplingImageProcessor(size: size)
    
    self.kf.setImage(
      with: url,
      placeholder: UIImage.catWithKeycap1,
      options: [
        .processor(processor),
        .scaleFactor(UIScreen.main.scale),
        .cacheOriginalImage
      ]
    )
  }
}
