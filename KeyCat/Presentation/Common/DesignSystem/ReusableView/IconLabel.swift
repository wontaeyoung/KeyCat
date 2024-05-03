//
//  IconLabel.swift
//  KeyCat
//
//  Created by 원태영 on 5/3/24.
//

import UIKit
import SnapKit

final class IconLabel: RxBaseView {
  
  let imageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFit
  }
  
  let label: KCLabel
  
  var image: UIImage? {
    didSet {
      self.imageView.image = image
    }
  }
  
  var title: String? {
    didSet {
      self.label.text = title
    }
  }
  
  init(
    image: UIImage? = nil,
    title: String? = nil,
    font: KCAsset.Font,
    color: KCAsset.Color = .black,
    line: Int = 1,
    alignment: NSTextAlignment = .natural
  ) {
    
    self.imageView.image = image?.withTintColor(color.color)
    imageView.tintColor = color.color
    self.label = KCLabel(title: title, font: font, color: color, line: line, alignment: alignment)
    
    super.init()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setHierarchy() {
    addSubviews(
      imageView,
      label
    )
  }
  
  override func setConstraint() {
    snp.makeConstraints { make in
      make.height.equalTo(label)
    }
    
    imageView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.size.equalTo(label.snp.height)
    }
    
    label.snp.makeConstraints { make in
      make.leading.equalTo(imageView.snp.trailing).offset(5)
      make.trailing.equalToSuperview()
    }
  }
}
