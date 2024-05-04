//
//  PostImageDetailSheetViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/30/24.
//

import UIKit
import SnapKit

final class PostImageDetailSheetViewController: RxBaseViewController {
  
  // MARK: - UI
  private let imageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFit
  }
  
  private lazy var leaveBarItem = UIBarButtonItem().configured {
    $0.image = KCAsset.Symbol.leaveButton
    setBarItem(at: .right, item: $0)
  }
  
  // MARK: - Initializer
  init(image: UIImage) {
    self.imageView.image = image
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(imageView)
  }
  
  override func setConstraint() {
    imageView.snp.makeConstraints { make in
      make.centerY.equalTo(view)
      make.horizontalEdges.equalTo(view)
      make.height.equalTo(imageView.snp.width)
    }
  }
  
  override func setAttribute() {
    view.backgroundColor = KCAsset.Color.black.color
  }
  
  override func bind() {
    leaveBarItem.rx.tap
      .buttonThrottle()
      .bind(with: self) { owner, _ in
        owner.dismiss(animated: true)
      }
      .disposed(by: disposeBag)
  }
}
