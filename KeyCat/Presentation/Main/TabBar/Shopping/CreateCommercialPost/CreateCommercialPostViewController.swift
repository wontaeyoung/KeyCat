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
  // MARK: 네비게이션 바
  private lazy var leaveBarButton = UIBarButtonItem().configured {
    $0.image = KCAsset.Symbol.leaveButton
    setBarItem(at: .right, item: $0)
  }
  
  // MARK: 뷰 컨테이너
  private let scrollView = UIScrollView().configured { $0.keyboardDismissMode = .onDrag }
  private let contentView = UIView()
  
  // MARK: 상품 이미지 컬렉션
  private let addImageButton = KCButton(
    style: .iconWithText,
    title: "0 / \(BusinessValue.Product.maxProductImage)",
    image: KCAsset.Symbol.addImageButton
  ).configured {
    $0.layer.configure {
      $0.borderColor = KCAsset.Color.lightGrayForeground.cgColor
      $0.borderWidth = 1
      $0.cornerRadius = 10
    }
  }
  
  private lazy var productImageCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: compositionalLayout
  ).configured {
    $0.register(
      CommercialPostImageCollectionCell.self,
      forCellWithReuseIdentifier: CommercialPostImageCollectionCell.identifier
    )
    $0.showsHorizontalScrollIndicator = false
    $0.keyboardDismissMode = .onDrag
  }
  
  private var compositionalLayout = UICollectionViewCompositionalLayout(
    section: .makeHorizontalScrollSection(
      itemSpacing: 20,
      sectionInset: .init(top: 10, leading: 0, bottom: 10, trailing: 20)
    )
  )
  
  // MARK: 상품 텍스트 정보
  private let titleLabel = KCLabel(style: .placeholder, title: "상품명")
  private let titleField = UITextField().configured {
    $0.borderStyle = .roundedRect
  }
  private let contentTextTitleLabel = KCLabel(style: .placeholder, title: "상품 설명")
  private let contentTextView = KCTextView(
    placeholder: "상품의 간단한 설명을 작성해주세요",
    maxLength: BusinessValue.Product.maxContentLength
  )
  private let lengthLabel = KCLabel(style: .placeholder, alignment: .right).configured {
    $0.textColor = KCAsset.Color.lightGrayForeground
  }
  
  // MARK: 가격 정보
  private let priceSectionLabel = KCLabel(style: .mainInfoTitle, title: "상품가")
  private lazy var priceInfoStack = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 30
    $0.addArrangedSubviews(
      regularPriceField,
      couponPriceField,
      discountPriceField,
      discountExpiryDateView
    )
  }
  private let regularPriceField = ValidationField(inputInformation: .regularPrice, type: .numberPad)
  private let discountPriceField = ValidationField(inputInformation: .discountPrice, type: .numberPad)
  private let couponPriceField = ValidationField(inputInformation: .coupon, type: .numberPad)
  private lazy var discountExpiryDateView = UIView().configured { view in
    view.addSubviews(
      discountExpiryDateTitleLabel,
      discountExpiryDatePicker
    )
    
    view.snp.makeConstraints { make in
      make.height.equalTo(discountExpiryDatePicker)
    }
    
    discountExpiryDateTitleLabel.snp.makeConstraints { make in
      make.leading.equalTo(view)
      make.centerY.equalTo(view)
      make.trailing.greaterThanOrEqualTo(discountExpiryDatePicker.snp.leading).offset(-20)
    }
    
    discountExpiryDatePicker.snp.makeConstraints { make in
      make.centerY.equalTo(view)
      make.trailing.equalTo(view)
    }
  }
  private let discountExpiryDateTitleLabel = KCLabel(style: .standardTitle, title: "할인 마감일")
  private let discountExpiryDatePicker = UIDatePicker().configured {
    $0.preferredDatePickerStyle = .compact
    $0.datePickerMode = .date
    $0.minimumDate = .now
    $0.locale = Constant.Config.koreaLocale
    $0.timeZone = Constant.Config.koreaTimeZone
  }
  
  // MARK: 배송 정보
  private let deliverySectionLabel = KCLabel(style: .mainInfoTitle, title: "배송")
  private lazy var deliveryInfoStack = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 20
    $0.addArrangedSubviews(
      selectDeliveryPriceView,
      selectDeliveryScheduleView
    )
  }
  private let selectDeliveryPriceView = KeyboardInfoSelectView(type: DeliveryInfo.Price.self)
  private let selectDeliveryScheduleView = KeyboardInfoSelectView(type: DeliveryInfo.Schedule.self)
  
  // MARK: 키보드 정보
  private let keyboardSectionLabel = KCLabel(style: .mainInfoTitle, title: "키보드")
  
  // MARK: 키보드 스펙 섹션
  private let keyboardInfoSectionLabel = KCLabel(style: .sectionTitle, title: "스펙")
  private lazy var keyboardInfoStack = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 20
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
  private let keyboardInfoDivider = Divider()
  private let selectPurposeView = KeyboardInfoSelectView(type: KeyboardInfo.Purpose.self)
  private let selectInputMechanismView = KeyboardInfoSelectView(type: KeyboardInfo.InputMechanism.self)
  private let selectConnectionTypeView = KeyboardInfoSelectView(type: KeyboardInfo.ConnectionType.self)
  private let selectPowerSourceView = KeyboardInfoSelectView(type: KeyboardInfo.PowerSource.self)
  private let selectBacklightView = KeyboardInfoSelectView(type: KeyboardInfo.Backlight.self)
  private let selectMechnicalSwitchView = KeyboardInfoSelectView(type: KeyboardInfo.MechanicalSwitch.self)
  private let selectCapacitiveSwitchView = KeyboardInfoSelectView(type: KeyboardInfo.CapacitiveSwitch.self)
  private let selectPCBTypeView = KeyboardInfoSelectView(type: KeyboardInfo.PCBType.self)
  
  // MARK: 키캡 정보 섹션
  private let keycapInfoSectionLabel = KCLabel(style: .sectionTitle, title: "키캡")
  private let keycapInfoDivider = Divider()
  private lazy var keycapInfoStack = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 20
    $0.addArrangedSubviews(
      selectKeycapProfileView,
      selectPrintingDirectionView,
      selectPrintingProcessView,
      selectPrintingLanguageView
    )
  }
  private let selectKeycapProfileView = KeyboardInfoSelectView(type: KeycapInfo.KeycapProfile.self)
  private let selectPrintingDirectionView = KeyboardInfoSelectView(type: KeycapInfo.PrintingDirection.self)
  private let selectPrintingProcessView = KeyboardInfoSelectView(type: KeycapInfo.PrintingProcess.self)
  private let selectPrintingLanguageView = KeyboardInfoSelectView(type: KeycapInfo.PrintingLanguage.self)
  
  // MARK: 키보드 디자인 섹션
  private let keyboardAppearanceInfoSectionLabel = KCLabel(style: .sectionTitle, title: "디자인")
  private let keyboardAppearanceInfoDivider = Divider()
  private lazy var keyboardAppearanceInfoStack = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 20
    $0.addArrangedSubviews(
      selectLayoutRatioView,
      selectKeyboardDesignView,
      selectMaterialView
    )
  }
  private let selectLayoutRatioView = KeyboardInfoSelectView(type: KeyboardAppearanceInfo.LayoutRatio.self)
  private let selectKeyboardDesignView = KeyboardInfoSelectView(type: KeyboardAppearanceInfo.KeyboardDesign.self)
  private let selectMaterialView = KeyboardInfoSelectView(type: KeyboardAppearanceInfo.Material.self)
  
  private let createPostButton = KCButton(style: .primary, title: "작성 완료")
  
  // MARK: - Property
  let viewModel: CreateCommercialPostViewModel
  
  // MARK: - Initializer
  init(viewModel: CreateCommercialPostViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      scrollView,
      createPostButton
    )
    scrollView.addSubviews(contentView)
    contentView.addSubviews(
      addImageButton,
      productImageCollectionView,
      
      titleLabel,
      titleField,
      contentTextTitleLabel,
      contentTextView,
      lengthLabel,
      
      priceSectionLabel,
      priceInfoStack,
      
      deliverySectionLabel,
      deliveryInfoStack,
      
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
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.horizontalEdges.equalTo(view)
      make.bottom.equalTo(createPostButton.snp.top)
    }
    
    contentView.snp.makeConstraints { make in
      make.width.equalTo(scrollView)
      make.verticalEdges.equalTo(scrollView)
    }
    
    addImageButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(20)
      make.centerY.equalTo(productImageCollectionView)
      make.size.equalTo(100)
    }
    
    productImageCollectionView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalTo(addImageButton.snp.trailing).offset(20)
      make.trailing.equalToSuperview()
      make.height.equalTo(120)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(productImageCollectionView.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    titleField.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    contentTextTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleField.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    contentTextView.snp.makeConstraints { make in
      make.top.equalTo(contentTextTitleLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview().inset(20)
      make.height.equalTo(300)
    }
    
    lengthLabel.snp.makeConstraints { make in
      make.top.equalTo(contentTextView.snp.bottom).offset(10)
      make.trailing.equalTo(contentTextView.snp.trailing)
    }
    
    priceSectionLabel.snp.makeConstraints { make in
      make.top.equalTo(lengthLabel.snp.bottom).offset(40)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    priceInfoStack.snp.makeConstraints { make in
      make.top.equalTo(priceSectionLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    deliverySectionLabel.snp.makeConstraints { make in
      make.top.equalTo(priceInfoStack.snp.bottom).offset(40)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    deliveryInfoStack.snp.makeConstraints { make in
      make.top.equalTo(deliverySectionLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    keyboardSectionLabel.snp.makeConstraints { make in
      make.top.equalTo(deliveryInfoStack.snp.bottom).offset(40)
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
      make.bottom.equalToSuperview().inset(20)
    }
    
    createPostButton.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
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
