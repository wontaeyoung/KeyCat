//
//  KeyboardInfoView.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import UIKit
import SnapKit
import RxCocoa

final class KeyboardInfoView: RxBaseView {
  
  private let keyboardSectionLabel = KCLabel(title: "키보드", font: .bold(size: 15), color: .darkGray)
  
  private lazy var keyboardInfoStack = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 10
    
    $0.addArrangedSubviews(
      purposeLabel,
      inputMechanismLabel,
      connectionTypeLabel,
      powerSourceLabel,
      backlightLabel,
      pcbTypeLabel
    )
  }
  
  private let purposeLabel = KeyboardInfoRowView(type: KeyboardInfo.Purpose.self)
  private let inputMechanismLabel = KeyboardInfoRowView(type: KeyboardInfo.InputMechanism.self)
  private let connectionTypeLabel = KeyboardInfoRowView(type: KeyboardInfo.ConnectionType.self)
  private let powerSourceLabel = KeyboardInfoRowView(type: KeyboardInfo.PowerSource.self)
  private let backlightLabel = KeyboardInfoRowView(type: KeyboardInfo.Backlight.self)
  private let pcbTypeLabel = KeyboardInfoRowView(type: KeyboardInfo.PCBType.self)
  
  var keyboard: Keyboard? {
    didSet {
      setData(keyboard: keyboard)
    }
  }
  
  override init() {
    super.init()
  }
  
  override func setHierarchy() {
    addSubviews(
      keyboardSectionLabel,
      keyboardInfoStack
    )
  }
  
  override func setConstraint() {
    keyboardSectionLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.horizontalEdges.equalToSuperview()
    }
    
    keyboardInfoStack.snp.makeConstraints { make in
      make.top.equalTo(keyboardSectionLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  private func setData(keyboard: Keyboard?) {
    guard let keyboard else { return }
    
    purposeLabel.info = keyboard.keyboardInfo.purpose
    inputMechanismLabel.info = keyboard.keyboardInfo.inputMechanism
    connectionTypeLabel.info = keyboard.keyboardInfo.connectionType
    powerSourceLabel.info = keyboard.keyboardInfo.powerSource
    backlightLabel.info = keyboard.keyboardInfo.backlight
    pcbTypeLabel.info = keyboard.keyboardInfo.pcbType
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
