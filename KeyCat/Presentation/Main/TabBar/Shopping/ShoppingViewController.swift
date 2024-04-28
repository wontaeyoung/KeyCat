//
//  ShoppingViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShoppingViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let createPostFloatingButton = KCButton(
    style: .icon,
    image: KCAsset.Symbol.createFloatingButton
  ).configured {
    $0.layer.configure {
      $0.shadowColor = KCAsset.Color.black.cgColor
      $0.shadowOffset = CGSize(width: 0, height: 2)
      $0.shadowOpacity = 0.5
      $0.shadowRadius = 2
    }
  }
  
  // MARK: - Property
  let viewModel: ShoppingViewModel
  
  // MARK: - Initializer
  init(viewModel: ShoppingViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(createPostFloatingButton)
  }
  
  override func setConstraint() {
    createPostFloatingButton.snp.makeConstraints { make in
      make.trailing.equalTo(view).inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
      make.size.equalTo(40)
    }
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    
    let input = ShoppingViewModel.Input()
    let output = viewModel.transform(input: input)
    
    output.hasSellerAuthority
      .map { !$0 }
      .drive(createPostFloatingButton.rx.isHidden)
      .disposed(by: disposeBag)
    
    input.viewDidLoadEvent.accept(())
  }
  
  // MARK: - Method
  
}
