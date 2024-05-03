//
//  DeliveryInfoView.swift
//  KeyCat
//
//  Created by 원태영 on 5/3/24.
//

import UIKit
import SnapKit

final class DeliveryInfoView: RxBaseView {
  
  private let deliverySectionLabel = KCLabel(title: "배송", font: .bold(size: 15), color: .darkGray)
  private let deliveryPriceLabel = IconLabel(image: KCAsset.Symbol.deliveryPrice, font: .bold(size: 14))
  private let deliveryScheduleLabel = IconLabel(image: KCAsset.Symbol.deliverySchedule, font: .bold(size: 14))
  
  var deliveryInfo: DeliveryInfo? {
    didSet {
      setData(deliveryInfo: deliveryInfo)
    }
  }
  
  override init() {
    super.init()
  }
  
  override func setHierarchy() {
    addSubviews(
      deliverySectionLabel,
      deliveryPriceLabel,
      deliveryScheduleLabel
    )
  }
  
  override func setConstraint() {
    deliverySectionLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.horizontalEdges.equalToSuperview()
    }
    
    deliveryPriceLabel.snp.makeConstraints { make in
      make.top.equalTo(deliverySectionLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview()
    }
    
    deliveryScheduleLabel.snp.makeConstraints { make in
      make.top.equalTo(deliveryPriceLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  private func setData(deliveryInfo: DeliveryInfo?) {
    guard let deliveryInfo else { return }
    
    deliveryPriceLabel.title = deliveryInfo.price.name
    deliveryScheduleLabel.title = "\(deliveryInfo.schedule.arrivingDay) 도착 보장"
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
