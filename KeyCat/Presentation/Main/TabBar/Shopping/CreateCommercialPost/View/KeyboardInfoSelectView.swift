//
//  KeyboardInfoSelectView.swift
//  KeyCat
//
//  Created by 원태영 on 4/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class KeyboardInfoSelectView<T: SelectionExpressible>: RxBaseView {
  
  private let titleLabel = KCLabel(font: .medium(size: 16))
  private let popUpButton = KCButton(style: .plain)
  
  let selectedOption: BehaviorRelay<T>
  
  init(type: T.Type) {
    
    self.selectedOption = BehaviorRelay<T>(value: type.coalesce)
    super.init()
    
    titleLabel.text = type.title
    setMenu(type: type)
  }
  
  override func setHierarchy() {
    addSubviews(
      titleLabel,
      popUpButton
    )
  }
  
  override func setConstraint() {
    snp.makeConstraints { make in
      make.height.equalTo(popUpButton)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(self)
      make.centerY.equalTo(self)
    }
    
    popUpButton.snp.makeConstraints { make in
      make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing)
      make.trailing.equalTo(self)
      make.centerY.equalTo(self)
    }
  }
  
  private func setMenu(type: T.Type) {
    let actions = type.selection
      .map { option in
        return UIAction(title: option.name) { _ in self.selectedOption.accept(option) }
      }
    
    let menu = UIMenu(title: type.title, children: actions)
    
    popUpButton.configure {
      $0.menu = menu
      $0.showsMenuAsPrimaryAction = true
      $0.changesSelectionAsPrimaryAction = true
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
