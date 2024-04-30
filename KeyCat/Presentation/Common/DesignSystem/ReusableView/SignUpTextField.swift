//
//  InputField.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ValidationField: KCField {
  
  // MARK: - UI
  let validationResultLabel = KCLabel(style: .caption)
  
  // MARK: - Property
  private let inputInformation: InputInformation
  let inputValidation = BehaviorRelay<Bool>(value: false)
  
  // MARK: - Initializer
  init(inputInformation: InputInformation, type: UIKeyboardType = .default) {
    self.inputInformation = inputInformation
    
    super.init(placeholder: inputInformation.title, clearable: false)
    self.keyboardType = type
    
    setLayout()
    bind()
  }
  
  // MARK: - Method
  private func setLayout() {
    self.addSubviews(validationResultLabel)
    
    validationResultLabel.snp.makeConstraints { make in
      make.top.equalTo(self.snp.bottom).offset(5)
      make.horizontalEdges.equalTo(self)
      make.height.equalTo(40)
    }
  }
  
  private func bind() {
    
    let currentInput = rx.text.orEmpty
    
    /// 유효성 검사 결과를 색상으로 변환해서 라벨에 전달
    inputValidation
      .map { $0 ? KCAsset.Color.correct : KCAsset.Color.incorrect }
      .bind(to: validationResultLabel.rx.textColor, rx.borderActiveColor)
      .disposed(by: disposeBag)
    
    /// 유효성 검사 결과를 문장으로 변환해서 라벨에 전달
    inputValidation
      .map { self.inputInformation.valitationInfoText(isValid: $0 ) }
      .bind(to: validationResultLabel.rx.text)
      .disposed(by: disposeBag)
    
    /// 입력 내용이 비어있으면 안내 라벨 숨기기
    currentInput
      .map { $0.isEmpty }
      .bind(to: validationResultLabel.rx.isHidden)
      .disposed(by: disposeBag)
    
    /// 정규식 일치 여부를 유효성 검사 결과 옵저버블에 전달
    /// 정규식 문자열이 비어있으면 검사하지 않음
    if !inputInformation.pattern.isEmpty {
      currentInput
        .map { $0.isMatch(pattern: self.inputInformation.pattern) }
        .bind(to: inputValidation)
        .disposed(by: disposeBag)
    }
  }
}
