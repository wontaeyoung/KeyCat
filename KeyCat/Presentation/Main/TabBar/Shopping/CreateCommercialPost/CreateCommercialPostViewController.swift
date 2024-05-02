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
import PhotosUI

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
    $0.allowsSelection = true
  }
  
  private let needImageInfoLabel = KCLabel(style: .placeholder, title: "이미지는 한 장 이상 추가해주세요")
  
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
  private let priceSectionLabel = KCLabel(style: .brandTitle, title: "상품가")
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
    $0.maximumDate = DateManager.shared.date(
      from: .now,
      as: .month,
      by: BusinessValue.Product.maxDiscountExpiryMonthFromNow
    )
    $0.locale = Constant.Config.koreaLocale
    $0.timeZone = Constant.Config.koreaTimeZone
  }
  
  // MARK: 배송 정보
  private let deliverySectionLabel = KCLabel(style: .brandTitle, title: "배송")
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
  private let keyboardSectionLabel = KCLabel(style: .brandTitle, title: "키보드")
  
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
      selectPCBTypeView
    )
  }
  private let keyboardInfoDivider = Divider()
  private let selectPurposeView = KeyboardInfoSelectView(type: KeyboardInfo.Purpose.self)
  private let selectInputMechanismView = KeyboardInfoSelectView(type: KeyboardInfo.InputMechanism.self)
  private let selectConnectionTypeView = KeyboardInfoSelectView(type: KeyboardInfo.ConnectionType.self)
  private let selectPowerSourceView = KeyboardInfoSelectView(type: KeyboardInfo.PowerSource.self)
  private let selectBacklightView = KeyboardInfoSelectView(type: KeyboardInfo.Backlight.self)
  private let selectMechanicalSwitchView = KeyboardInfoSelectView(type: KeyboardInfo.MechanicalSwitch.self)
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
  
  private var imageContainer: [UIImage] = [] {
    willSet {
      images.accept(newValue)
    }
  }
  
  private let images = BehaviorRelay<[UIImage]>(value: [])
  
  private let phPickerConfiguration = PHPickerConfiguration().applied {
    $0.selectionLimit = BusinessValue.Product.maxProductImage
    $0.filter = .images
    $0.selection = .ordered
  }
  
  private lazy var phPicker = PHPickerViewController(configuration: phPickerConfiguration).configured {
    $0.delegate = self
  }
  
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
      needImageInfoLabel,
      
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
    
    needImageInfoLabel.snp.makeConstraints { make in
      make.top.equalTo(productImageCollectionView.snp.bottom)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(needImageInfoLabel.snp.bottom).offset(20)
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
    
    let input = CreateCommercialPostViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 작성 버튼 활성화 여부 변경
    output.postCreatable
      .map { $0 && self.images.value.isFilled }
      .drive(createPostButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    /// 작성 완료 토스트 안내 > 토스트 완료 이벤트 전달
    output.isSuccessCreatePost
      .drive(with: self) { owner, success in
        owner.createPostButton.stopIndicator()
        
        if success {
          owner.toast("판매글 작성이 완료되었어요.") { input.toastCompleteEvent.accept(()) }
        }
      }
      .disposed(by: disposeBag)
    
    /// 상품명 입력 전달
    titleField.rx.text.orEmpty
      .bind(to: input.title)
      .disposed(by: disposeBag)
    
    /// 상품 설명 입력 전달
    contentTextView.rx.text.orEmpty
      .bind(to: input.content)
      .disposed(by: disposeBag)
    
    /// 상품가 입력 전달
    regularPriceField.rx.text.orEmpty
      .compactMap { Int($0) }
      .bind(to: input.regularPrice)
      .disposed(by: disposeBag)
    
    /// 쿠폰가 입력 전달
    couponPriceField.rx.text.orEmpty
      .compactMap { Int($0) }
      .bind(to: input.couponPrice)
      .disposed(by: disposeBag)
    
    /// 할인가 입력 전달
    discountPriceField.rx.text.orEmpty
      .compactMap { Int($0) }
      .bind(to: input.discountPrice)
      .disposed(by: disposeBag)
    
    /// 할인마감일 전달
    discountExpiryDatePicker.rx.date
      .bind(to: input.discountExpiry)
      .disposed(by: disposeBag)
    
    /// 배송비 선택 전달
    selectDeliveryPriceView.selectedOption
      .bind(to: input.deliveryPrice)
      .disposed(by: disposeBag)
    
    /// 배송일 선택 전달
    selectDeliveryScheduleView.selectedOption
      .bind(to: input.deliverySchedule)
      .disposed(by: disposeBag)
    
    /// 배송비 선택 전달
    selectPurposeView.selectedOption
      .bind(to: input.purpose)
      .disposed(by: disposeBag)
    
    /// 입력 메커니즘 전달
    selectInputMechanismView.selectedOption
      .bind(to: input.inputMechanism)
      .disposed(by: disposeBag)
    
    selectConnectionTypeView.selectedOption
      .bind(to: input.connectionType)
      .disposed(by: disposeBag)
    
    selectPowerSourceView.selectedOption
      .bind(to: input.powerSource)
      .disposed(by: disposeBag)
    
    selectBacklightView.selectedOption
      .bind(to: input.backlight)
      .disposed(by: disposeBag)
    
    selectPCBTypeView.selectedOption
      .bind(to: input.pcbType)
      .disposed(by: disposeBag)
    
    selectMechanicalSwitchView.selectedOption
      .bind(to: input.mechanicalSwitch)
      .disposed(by: disposeBag)
    
    selectCapacitiveSwitchView.selectedOption
      .bind(to: input.capacitiveSwitch)
      .disposed(by: disposeBag)
    
    selectKeycapProfileView.selectedOption
      .bind(to: input.keycapProfile)
      .disposed(by: disposeBag)
    
    selectPrintingDirectionView.selectedOption
      .bind(to: input.printingDirection)
      .disposed(by: disposeBag)
    
    selectPrintingProcessView.selectedOption
      .bind(to: input.printingProcess)
      .disposed(by: disposeBag)
    
    selectPrintingLanguageView.selectedOption
      .bind(to: input.printingLanguage)
      .disposed(by: disposeBag)
    
    selectLayoutRatioView.selectedOption
      .bind(to: input.layoutRatio)
      .disposed(by: disposeBag)
    
    selectKeyboardDesignView.selectedOption
      .bind(to: input.keyboardDesign)
      .disposed(by: disposeBag)
    
    selectMaterialView.selectedOption
      .bind(to: input.material)
      .disposed(by: disposeBag)
    
    /// 작성 중단 바 버튼 이벤트 전달
    leaveBarButton.rx.tap
      .buttonThrottle()
      .bind(to: input.leaveTapEvent)
      .disposed(by: disposeBag)
    
    /// 이미지 추가 버튼 > 이미지 선택 뷰 표시
    addImageButton.rx.tap
      .buttonThrottle()
      .bind(with: self) { owner, _ in
        owner.present(owner.phPicker, animated: true)
      }
      .disposed(by: disposeBag)
    
    /// 현재 이미지 갯수를 이미지 추가 버튼 라벨에 반영
    images
      .map { "\($0.count) / \(BusinessValue.Product.maxProductImage)" }
      .bind(to: addImageButton.rx.title())
      .disposed(by: disposeBag)
    
    /// 이미지 갯수 > 이미지 추가 요구 라벨 표시여부 반영
    images
      .map { $0.isFilled }
      .bind(to: needImageInfoLabel.rx.isHidden)
      .disposed(by: disposeBag)
    
    /// 현재 이미지로 이미지 컬렉션 뷰 그리기
    images
      .bind(to: productImageCollectionView.rx.items(
        cellIdentifier: CommercialPostImageCollectionCell.identifier,
        cellType: CommercialPostImageCollectionCell.self)
      ) { row, item, cell in
        cell.updateImage(with: item, row: row)
      }
      .disposed(by: disposeBag)
    
    /// 셀 선택 > 이미지 디테일 시트뷰 표시
    productImageCollectionView.rx.modelSelected(UIImage.self)
      .bind(with: self) { owner, image in
        let vc = UINavigationController(rootViewController: PostImageDetailSheetViewController(image: image))
        vc.modalPresentationStyle = .fullScreen
        
        owner.present(vc, animated: true)
      }
      .disposed(by: disposeBag)
    
    /// 입력방식 변경 > 스위치 선택 뷰 표시 여부 변경
    selectInputMechanismView.selectedOption
      .bind(with: self) { owner, inputMechanism in
        owner.updateSwitchSelectionLayout(inputMechanism: inputMechanism)
      }
      .disposed(by: disposeBag)
    
    /// 작성 버튼 > 현재 이미지 -> 데이터 변환 -> 이벤트 전달
    createPostButton.rx.tap
      .buttonThrottle()
      .do (onNext: { self.createPostButton.showIndicator() })
      .withLatestFrom(images)
      .map {
        $0.compactMap { $0.compressedJPEGData }
      }
      .bind(to: input.createPostTapEvent)
      .disposed(by: disposeBag)
    
  }
  
  // MARK: - Method
  private func updateSwitchSelectionLayout(inputMechanism: KeyboardInfo.InputMechanism) {
    
    keyboardInfoStack.removeArrangedSubviews(
      selectMechanicalSwitchView,
      selectCapacitiveSwitchView
    )
    
    switch inputMechanism {
      case .mechanical:
        keyboardInfoStack.addArrangedSubview(selectMechanicalSwitchView)
        
      case .capacitiveNonContact:
        keyboardInfoStack.addArrangedSubview(selectCapacitiveSwitchView)
        
      default:
        break
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  return UINavigationController(
    rootViewController: CreateCommercialPostViewController(
      viewModel: CreateCommercialPostViewModel()
    )
  )
}

extension CreateCommercialPostViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    
    imageContainer.removeAll()
    
    results.forEach { result in
      let itemProvider = result.itemProvider
      guard itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
      
      itemProvider.loadObject(ofClass: UIImage.self) { item, error in
        guard let image = item as? UIImage else { return }
        
        GCD.main { [weak self] in
          self?.imageContainer.append(image)
        }
      }
    }
    
    dismiss(animated: true)
  }
}
