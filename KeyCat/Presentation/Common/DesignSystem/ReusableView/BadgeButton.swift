//
//  BadgeButton.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import UIKit
import SnapKit

final class BadgeButton: RxBaseView {
  
  let button = KCButton(style: .icon, image: KCAsset.Symbol.cart)
  let badgeLabel = TagLabel(title: nil,
    horizontalInset: 4,
    verticalInset: 2,
    color: .white,
    backgroundColor: .red
  )
  
  var image: UIImage? {
    didSet {
      button.image(image)
    }
  }
  
  var title: String? {
    didSet {
      self.badgeLabel.text = title
    }
  }
  
  init(
    image: UIImage? = nil,
    title: String? = nil
  ) {
    self.image = image
    self.title = title
    
    super.init()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setHierarchy() {
    addSubviews(
      button,
      badgeLabel
    )
  }
  
  override func setConstraint() {
    button.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    badgeLabel.snp.makeConstraints { make in
      make.top.trailing.equalTo(button)
    }
  }
}
