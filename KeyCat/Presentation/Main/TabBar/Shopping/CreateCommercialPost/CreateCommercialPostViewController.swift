//
//  CreateCommercialPostViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CreateCommercialPostViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let titleField = ProductField(placeholder: "상품명")
  private let inputMechanism = KeyboardInfoSegmentView(type: KeyboardInfo.InputMechanism.self)
  private let test = UISegmentedControl(items: KeyboardInfo.ConnectionType.selection.map { $0.name} )
  
  // MARK: - Property
  let viewModel: CreateCommercialPostViewModel
  
  // MARK: - Initializer
  init(viewModel: CreateCommercialPostViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(scrollView)
    scrollView.addSubviews(contentView)
    contentView.addSubviews(
      titleField,
      inputMechanism,
      test
    )
  }
  
  override func setConstraint() {
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    contentView.snp.makeConstraints { make in
      make.width.equalTo(scrollView)
      make.verticalEdges.equalTo(scrollView)
    }
    
    titleField.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    inputMechanism.snp.makeConstraints { make in
      make.top.equalTo(titleField.snp.bottom).offset(50)
      make.horizontalEdges.equalToSuperview().inset(20)
      make.height.equalTo(100)
    }
    
    test.snp.makeConstraints { make in
      make.top.equalTo(inputMechanism.snp.bottom).offset(50)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  override func setAttribute() {
    scrollView.isUserInteractionEnabled = true
    contentView.isUserInteractionEnabled = true
  }
  
  override func bind() {
    inputMechanism.selectedOption
      .bind { print($0.name) }
      .disposed(by: disposeBag)
    
    test.rx.selectedSegmentIndex
      .bind {
        print($0)
      }
      .disposed(by: disposeBag)
  }
  
  // MARK: - Method
  
}

@available(iOS 17.0, *)
#Preview {
  return UINavigationController(
    rootViewController: CreateCommercialPostViewController(
      viewModel: CreateCommercialPostViewModel()
    )
  )
}
