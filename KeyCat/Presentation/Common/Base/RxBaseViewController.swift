//
//  RxBaseViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RxBaseViewController: UIViewController {
  
  class var identifier: String {
    return self.description()
  }
  
  private let networkUnsatisfiedView = UIView().configured {
    let imageView = UIImageView(image: KCAsset.Symbol.networkDisconnect).configured {
      $0.tintColor = KCAsset.Color.darkGray
    }
    
    let label = KCLabel(
      style: .standardTitle,
      title: "네트워크가 원활하지 않습니다.\n연결 상태를 다시 확인해주세요.",
      alignment: .center
    )
      .configured {
        $0.numberOfLines = 2
      }
    
    $0.addSubviews(imageView, label)
    
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
  
  // MARK: - Property
  var disposeBag = DisposeBag()
  let tap = PublishRelay<Void>()
  
  // MARK: - Initializer
  init() {
    super.init(nibName: nil, bundle: nil)
    
    let tapGesture = UITapGestureRecognizer()
    view.addGestureRecognizer(tapGesture)
    
    tapGesture.rx.event
      .buttonThrottle(seconds: 1)
      .map { _ in () }
      .bind(to: tap)
      .disposed(by: disposeBag)
    
    NetworkMonitor.shared.networkStateSatisfied
      .thread(.main)
      .bind(with: self) { owner, isSatisfied in
        owner.updateNetworkUnsatisfiedViewVisibility(isSatisfied: isSatisfied)
      }
      .disposed(by: disposeBag)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  func setHierarchy() { }
  func setConstraint() { }
  func setAttribute() { }
  func bind() { }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    view.backgroundColor = KCAsset.Color.background
    
    setHierarchy()
    setConstraint()
    setAttribute()
    bind()
  }
  
  private func updateNetworkUnsatisfiedViewVisibility(isSatisfied: Bool) {
    
    if isSatisfied {
      networkUnsatisfiedView.snp.removeConstraints()
      networkUnsatisfiedView.removeFromSuperview()
    } else {
      view.addSubview(networkUnsatisfiedView)
      
      networkUnsatisfiedView.snp.makeConstraints { make in
        make.edges.equalTo(view)
      }
    }
  }
}
