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
  
  private let specSectionLabel = KCLabel(title: "키보드", font: .bold(size: 15), color: .darkGray)
  private let keycapSectionLabel = KCLabel(title: "키캡", font: .bold(size: 15), color: .darkGray)
  private let appearanceSectionLabel = KCLabel(title: "외관", font: .bold(size: 15), color: .darkGray)
  
  private lazy var specStack = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 20
    
    $0.addArrangedSubviews(
      purposeView,
      inputMechanismView,
      connectionTypeView,
      powerSourceView,
      backlightView,
      pcbTypeView
    )
  }
  
  private lazy var keycapStack = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 20
    
    $0.addArrangedSubviews(
      keycapProfileView,
      printingDirectionView,
      printingProcessView,
      printingLanguageView
    )
  }
  
  private lazy var designStack = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 20
    
    $0.addArrangedSubviews(
      layoutRatioView,
      keyboardDesignView,
      materialView
    )
  }
  
  private let purposeView = KeyboardInfoRowView(type: KeyboardInfo.Purpose.self)
  private let inputMechanismView = KeyboardInfoRowView(type: KeyboardInfo.InputMechanism.self)
  private let connectionTypeView = KeyboardInfoRowView(type: KeyboardInfo.ConnectionType.self)
  private let powerSourceView = KeyboardInfoRowView(type: KeyboardInfo.PowerSource.self)
  private let backlightView = KeyboardInfoRowView(type: KeyboardInfo.Backlight.self)
  private let pcbTypeView = KeyboardInfoRowView(type: KeyboardInfo.PCBType.self)
  
  private let keycapProfileView = KeyboardInfoRowView(type: KeycapInfo.KeycapProfile.self)
  private let printingDirectionView = KeyboardInfoRowView(type: KeycapInfo.PrintingDirection.self)
  private let printingProcessView = KeyboardInfoRowView(type: KeycapInfo.PrintingProcess.self)
  private let printingLanguageView = KeyboardInfoRowView(type: KeycapInfo.PrintingLanguage.self)
  
  private let layoutRatioView = KeyboardInfoRowView(type: KeyboardAppearanceInfo.LayoutRatio.self)
  private let keyboardDesignView = KeyboardInfoRowView(type: KeyboardAppearanceInfo.KeyboardDesign.self)
  private let materialView = KeyboardInfoRowView(type: KeyboardAppearanceInfo.Material.self)
  
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
      specSectionLabel,
      specStack,
      keycapSectionLabel,
      keycapStack,
      appearanceSectionLabel,
      designStack
    )
  }
  
  override func setConstraint() {
    specSectionLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.horizontalEdges.equalToSuperview()
    }
    
    specStack.snp.makeConstraints { make in
      make.top.equalTo(specSectionLabel.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview()
    }
    
    keycapSectionLabel.snp.makeConstraints { make in
      make.top.equalTo(specStack.snp.bottom).offset(60)
      make.horizontalEdges.equalToSuperview()
    }
    
    keycapStack.snp.makeConstraints { make in
      make.top.equalTo(keycapSectionLabel.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview()
    }
    
    appearanceSectionLabel.snp.makeConstraints { make in
      make.top.equalTo(keycapStack.snp.bottom).offset(60)
      make.horizontalEdges.equalToSuperview()
    }
    
    designStack.snp.makeConstraints { make in
      make.top.equalTo(appearanceSectionLabel.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  private func setData(keyboard: Keyboard?) {
    guard let keyboard else { return }
    
    purposeView.info = keyboard.keyboardInfo.purpose
    inputMechanismView.info = keyboard.keyboardInfo.inputMechanism
    connectionTypeView.info = keyboard.keyboardInfo.connectionType
    powerSourceView.info = keyboard.keyboardInfo.powerSource
    backlightView.info = keyboard.keyboardInfo.backlight
    pcbTypeView.info = keyboard.keyboardInfo.pcbType
    
    keycapProfileView.info = keyboard.keycapInfo.profile
    printingDirectionView.info = keyboard.keycapInfo.direction
    printingProcessView.info = keyboard.keycapInfo.process
    printingLanguageView.info = keyboard.keycapInfo.language

    layoutRatioView.info = keyboard.keyboardAppearanceInfo.ratio
    keyboardDesignView.info = keyboard.keyboardAppearanceInfo.design
    materialView.info = keyboard.keyboardAppearanceInfo.material
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
