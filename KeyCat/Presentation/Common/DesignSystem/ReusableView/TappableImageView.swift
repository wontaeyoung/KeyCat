//
//  TappableImageView.swift
//  KeyCat
//
//  Created by 원태영 on 4/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TappableImageView: UIImageView {
  
  private let disposeBag = DisposeBag()
  let tap = PublishRelay<Void>()
  
  override init(image: UIImage?) {
    super.init(image: image)
    
    self.isUserInteractionEnabled = true
    
    let tapGesture = UITapGestureRecognizer()
    self.addGestureRecognizer(tapGesture)
    
    tapGesture.rx.event
      .buttonThrottle(seconds: 1)
      .map { _ in () }
      .bind(to: tap)
      .disposed(by: disposeBag)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
