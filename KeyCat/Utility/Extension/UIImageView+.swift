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
    
    let size = UIScreen.main.bounds.width
    let cgSize = CGSize(width: size, height: size)
    let processor = DownsamplingImageProcessor(size: cgSize)
    
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
