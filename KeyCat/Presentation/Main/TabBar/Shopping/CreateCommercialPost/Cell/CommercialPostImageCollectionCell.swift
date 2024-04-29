//
//  CommercialPostImageCollectionCell.swift
//  KeyCat
//
//  Created by 원태영 on 4/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

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
  
  private let deleteImageButton = KCButton(style: .icon, image: KCAsset.Symbol.closeButton)
  
  // MARK: - Observable
  private let indexRelay = BehaviorRelay<Int>(value: 0)
  
  // MARK: - Life Cycle
  override func prepareForReuse() {
    disposeBag = DisposeBag()
  }
  
  override func setHierarchy() {
    contentView.addSubviews(
      imageView,
      deleteImageButton
    )
  }
  
  override func setConstraint() {
    imageView.snp.makeConstraints { make in
      make.edges.equalTo(contentView)
    }
    
    deleteImageButton.snp.makeConstraints { make in
      make.top.trailing.equalTo(imageView).inset(-15)
      make.size.equalTo(40)
    }
  }
}

extension CommercialPostImageCollectionCell {
  
  func updateImage(with image: UIImage, at index: Int, tapEvent: PublishRelay<Int>) {
    imageView.image = image
    indexRelay.accept(index)
    
    bindDeleteButtonTapEvent(tapEvent)
  }
  
  private func bindDeleteButtonTapEvent(_ tapEvent: PublishRelay<Int>) {
    deleteImageButton.rx.tap
      .buttonThrottle()
      .withLatestFrom(indexRelay)
      .bind(to: tapEvent)
      .disposed(by: disposeBag)
  }
}
