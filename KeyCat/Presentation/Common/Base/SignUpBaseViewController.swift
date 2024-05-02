//
//  SignUpBaseViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

import UIKit
import RxSwift

class SignUpBaseViewController: TappableBaseViewController {
  
  let inputInfoTitleLabel = KCLabel(style: .brandTitle)
  let nextButton = KCButton(style: .primary, title: Constant.Button.next)
  private let bottomBufferHeight: CGFloat = 20
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindKeyboard()
    bindEndEditing()
  }
  
  init(inputInfoTitle: String) {
    super.init()
    
    inputInfoTitleLabel.text = inputInfoTitle
  }
  
  override func setHierarchy() {
    view.addSubviews(inputInfoTitleLabel, nextButton)
  }
  
  override func setConstraint() {
    inputInfoTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.horizontalEdges.equalTo(view).inset(20)
    }
    
    nextButton.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(bottomBufferHeight)
    }
  }
  
  private func bindKeyboard() {
    // 키보드 나타남 감지
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .map {
        guard let height = ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
          return 0
        }
        
        return height
      }
      .bind(with: self) { owner, height in
        owner.updateButtonPosition(keyboardHeight: height)
      }
      .disposed(by: disposeBag)
    
    // 키보드 사라짐 감지
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .bind(with: self) { owner, _ in
        owner.updateButtonPosition(keyboardHeight: 0)
      }
      .disposed(by: disposeBag)
  }
  
  private func bindEndEditing() {
    tap
      .bind(with: self) { owner, _ in
        owner.view.endEditing(true)
      }
      .disposed(by: disposeBag)
  }
  
  private func updateButtonPosition(keyboardHeight: CGFloat) {
    let updateHeight = keyboardHeight + bottomBufferHeight
    
    UIView.animate(withDuration: 0.3) {
      self.nextButton.snp.updateConstraints { make in
        make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-updateHeight)
      }
      
      self.view.layoutIfNeeded()
    }
  }
}
