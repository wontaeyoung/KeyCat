//
//  TagLabel.swift
//  KeyCat
//
//  Created by 원태영 on 5/2/24.
//

import UIKit

final class TagLabel: KCLabel {
  
  // MARK: - Property
  var horizontalInset: CGFloat
  var verticalInset: CGFloat
  
  // MARK: - Initializer
  init(
    title: String?,
    horizontalInset: CGFloat = 8,
    verticalInset: CGFloat = 4,
    color: KCAsset.Color = .white,
    backgroundColor: KCAsset.Color
  ) {
    self.horizontalInset = horizontalInset
    self.verticalInset = verticalInset
    
    super.init(
      title: title,
      font: .bold(size: 12),
      color: color,
      alignment: .center
    )
    
    self.backgroundColor = backgroundColor.color
    self.clipsToBounds = true
    self.layer.cornerRadius = 5
    
    if backgroundColor == .white {
      self.layer.configure {
        $0.borderColor = color.color.cgColor
        $0.borderWidth = 1
      }
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets(
      top: verticalInset,
      left: horizontalInset,
      bottom: verticalInset,
      right: horizontalInset
    )
    super.drawText(in: rect.inset(by: insets))
  }
  
  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(
      width: size.width + horizontalInset * 2,
      height: size.height + verticalInset * 2
    )
  }
  
  override var bounds: CGRect {
    didSet {
      preferredMaxLayoutWidth = bounds.width - horizontalInset * 2
    }
  }
}
