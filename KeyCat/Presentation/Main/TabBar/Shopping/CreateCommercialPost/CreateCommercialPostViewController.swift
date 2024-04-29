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
  private let scrollView = UIScrollView().configured {
    $0.keyboardDismissMode = .onDrag
  }
  private let contentView = UIView()
  private let titleField = ProductField(placeholder: "상품명")
  
  private let keyboardSectionLabel = KCLabel(style: .mainInfoTitle, title: "키보드")
  private let keyboardInfoSectionLabel = KCLabel(style: .sectionTitle, title: "스펙")
  private let keyboardInfoDivider = Divider()
  private let keycapInfoSectionLabel = KCLabel(style: .sectionTitle, title: "키캡")
  private let keycapInfoDivider = Divider()
  private let keyboardAppearanceInfoSectionLabel = KCLabel(style: .sectionTitle, title: "디자인")
  private let keyboardAppearanceInfoDivider = Divider()
  
  private lazy var keyboardInfoStack = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 15
    $0.addArrangedSubviews(
      selectPurposeView,
      selectInputMechanismView,
      selectConnectionTypeView,
      selectPowerSourceView,
      selectBacklightView,
      selectMechnicalSwitchView,
      selectCapacitiveSwitchView,
      selectPCBTypeView
    )
  }
  
  private lazy var keycapInfoStack = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 15
    $0.addArrangedSubviews(
      selectKeycapProfileView,
      selectPrintingDirectionView,
      selectPrintingProcessView,
      selectPrintingLanguageView
    )
  }
  
  private lazy var keyboardAppearanceInfoStack = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 15
    $0.addArrangedSubviews(
      selectLayoutRatioView,
      selectKeyboardDesignView,
      selectMaterialView
    )
  }
  
  /// 키보드 스펙
  private let selectPurposeView = KeyboardInfoSelectView(type: KeyboardInfo.Purpose.self)
  private let selectInputMechanismView = KeyboardInfoSelectView(type: KeyboardInfo.InputMechanism.self)
  private let selectConnectionTypeView = KeyboardInfoSelectView(type: KeyboardInfo.ConnectionType.self)
  private let selectPowerSourceView = KeyboardInfoSelectView(type: KeyboardInfo.PowerSource.self)
  private let selectBacklightView = KeyboardInfoSelectView(type: KeyboardInfo.Backlight.self)
  private let selectMechnicalSwitchView = KeyboardInfoSelectView(type: KeyboardInfo.MechanicalSwitch.self)
  private let selectCapacitiveSwitchView = KeyboardInfoSelectView(type: KeyboardInfo.CapacitiveSwitch.self)
  private let selectPCBTypeView = KeyboardInfoSelectView(type: KeyboardInfo.PCBType.self)
  
  /// 키캡 정보
  private let selectKeycapProfileView = KeyboardInfoSelectView(type: KeycapInfo.KeycapProfile.self)
  private let selectPrintingDirectionView = KeyboardInfoSelectView(type: KeycapInfo.PrintingDirection.self)
  private let selectPrintingProcessView = KeyboardInfoSelectView(type: KeycapInfo.PrintingProcess.self)
  private let selectPrintingLanguageView = KeyboardInfoSelectView(type: KeycapInfo.PrintingLanguage.self)
  
  /// 키보드 디자인
  private let selectLayoutRatioView = KeyboardInfoSelectView(type: KeyboardAppearanceInfo.LayoutRatio.self)
  private let selectKeyboardDesignView = KeyboardInfoSelectView(type: KeyboardAppearanceInfo.KeyboardDesign.self)
  private let selectMaterialView = KeyboardInfoSelectView(type: KeyboardAppearanceInfo.Material.self)
  
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
      
      keyboardSectionLabel,
      
      keyboardInfoSectionLabel,
      keyboardInfoDivider,
      keyboardInfoStack,
      
      keycapInfoSectionLabel,
      keycapInfoDivider,
      keycapInfoStack,
      
      keyboardAppearanceInfoSectionLabel,
      keyboardAppearanceInfoDivider,
      keyboardAppearanceInfoStack
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
      make.top.equalTo(contentView)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    keyboardSectionLabel.snp.makeConstraints { make in
      make.top.equalTo(titleField.snp.bottom).offset(40)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    keyboardInfoSectionLabel.snp.makeConstraints { make in
      make.top.equalTo(keyboardSectionLabel.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    keyboardInfoDivider.snp.makeConstraints { make in
      make.top.equalTo(keyboardInfoSectionLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    keyboardInfoStack.snp.makeConstraints { make in
      make.top.equalTo(keyboardInfoDivider.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    keycapInfoSectionLabel.snp.makeConstraints { make in
      make.top.equalTo(keyboardInfoStack.snp.bottom).offset(40)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    keycapInfoDivider.snp.makeConstraints { make in
      make.top.equalTo(keycapInfoSectionLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    keycapInfoStack.snp.makeConstraints { make in
      make.top.equalTo(keycapInfoDivider.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    keyboardAppearanceInfoSectionLabel.snp.makeConstraints { make in
      make.top.equalTo(keycapInfoStack.snp.bottom).offset(40)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    keyboardAppearanceInfoDivider.snp.makeConstraints { make in
      make.top.equalTo(keyboardAppearanceInfoSectionLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    keyboardAppearanceInfoStack.snp.makeConstraints { make in
      make.top.equalTo(keyboardAppearanceInfoDivider.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview().inset(20)
      make.bottom.equalToSuperview()
    }
  }
  
  override func setAttribute() {
    scrollView.isUserInteractionEnabled = true
    contentView.isUserInteractionEnabled = true
  }
  
  override func bind() {
    
    selectInputMechanismView.selectedOption
      .bind {
        print($0.name)
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
