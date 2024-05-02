//
//  CommercialPostDetailImageCollectionCell.swift
//  KeyCat
//
//  Created by 원태영 on 5/2/24.
//

import UIKit
import SnapKit

final class CommercialPostDetailImageCollectionCell: RxBaseCollectionViewCell {
  
  // MARK: - UI
  private let imageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFill
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
  
  func updateImage(with image: UIImage) {
    imageView.image = image
  }
}
