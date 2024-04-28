//
//  KeyboardInfoSegment.swift
//  KeyCat
//
//  Created by 원태영 on 4/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class KeyboardInfoSegmentView<T: SelectionExpressible>: UIView {
  
  private let scrollView = UIScrollView().configured {
    $0.showsHorizontalScrollIndicator = false
  }
  private let titleLabel = KCLabel(style: .standardTitle)
  private let segment: UISegmentedControl
  
  private let disposeBag = DisposeBag()
  let selectedOption: BehaviorRelay<T>
  
  init(type: T.Type) {
    selectedOption = BehaviorRelay<T>(value: type.coalesce)
    segment = UISegmentedControl(items: type.selection.map { $0.name })
    super.init(frame: .zero)
    
    titleLabel.text = type.title
    segment.selectedSegmentIndex = type.coalesce.index
    
    addSubviews(titleLabel, scrollView)
    scrollView.addSubviews(segment)
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self)
      make.horizontalEdges.equalTo(self)
      make.height.equalTo(20)
    }
    
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
      make.bottom.equalTo(self)
      make.width.equalTo(self)
      make.height.equalTo(segment).multipliedBy(1.2)
    }
    
    segment.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(scrollView)
    }
    
    segment.rx.selectedSegmentIndex
      .map { T($0) }
      .bind(to: selectedOption)
      .disposed(by: disposeBag)
    
    segment.rx.selectedSegmentIndex
      .bind(with: self) { owner, index in
        owner.scrollTo(to: index)
      }
      .disposed(by: disposeBag)
  }
  
  private func scrollTo(to index: Int) {
    let segmentWidth = segment.frame.width / CGFloat(segment.numberOfSegments)
    let offset = CGPoint(x: segmentWidth * CGFloat(index) - scrollView.frame.width / 2 + segmentWidth / 2, y: 0)
    scrollView.setContentOffset(offset, animated: true)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
