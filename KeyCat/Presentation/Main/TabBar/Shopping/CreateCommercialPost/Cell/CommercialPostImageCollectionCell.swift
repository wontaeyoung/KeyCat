//
//  CommercialPostImageCollectionCell.swift
//  KeyCat
//
//  Created by 원태영 on 4/29/24.
//

import UIKit
import SnapKit

final class CommercialPostImageCollectionCell: RxBaseCollectionViewCell {
  
  // MARK: - UI
  private let imageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.configure {
      $0.cornerRadius = 10
      $0.borderColor = KCAsset.Color.lightGrayBackground.cgColor
      $0.borderWidth = 1
    }
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(imageView)
  }
  
  override func setConstraint() {
    imageView.snp.makeConstraints { make in
      make.edges.equalTo(contentView)
    }
  }
}

extension CommercialPostImageCollectionCell {
  
  func updateImage(with image: UIImage) {
    imageView.image = image
  }
}
