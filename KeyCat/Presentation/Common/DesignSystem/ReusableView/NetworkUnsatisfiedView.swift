//
//  NetworkUnsatisfiedView.swift
//  KeyCat
//
//  Created by 원태영 on 5/10/24.
//

import UIKit
import SnapKit

final class NetworkUnsatisfiedView: UIView {
  
  let imageView = UIImageView(image: KCAsset.Symbol.networkDisconnect).configured {
    $0.tintColor = KCAsset.Color.black.color
  }
  
  let label = KCLabel(
    title: "네트워크가 원활하지 않습니다.\n연결 상태를 다시 확인해주세요.",
    font: .bold(size: 18),
    line: 2,
    alignment: .center
  )
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = KCAsset.Color.white.color.withAlphaComponent(0.8)
    addSubviews(imageView, label)
    
    imageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(label.snp.top).offset(-20)
      make.size.equalTo(100)
    }
    
    label.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
