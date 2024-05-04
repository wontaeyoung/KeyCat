//
//  CreateCommercialPostViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CreateCommercialPostViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let title: BehaviorRelay<String>
    let content: BehaviorRelay<String>
    
    let regularPrice: BehaviorRelay<Int>
    let couponPrice: BehaviorRelay<Int>
    let discountPrice: BehaviorRelay<Int>
    let discountExpiry: BehaviorRelay<Date>
    
    let deliveryPrice: BehaviorRelay<DeliveryInfo.Price>
    let deliverySchedule: BehaviorRelay<DeliveryInfo.Schedule>
    
    let purpose: BehaviorRelay<KeyboardInfo.Purpose>
    let inputMechanism: BehaviorRelay<KeyboardInfo.InputMechanism>
    let connectionType: BehaviorRelay<KeyboardInfo.ConnectionType>
    let powerSource: BehaviorRelay<KeyboardInfo.PowerSource>
    let backlight: BehaviorRelay<KeyboardInfo.Backlight>
    let pcbType: BehaviorRelay<KeyboardInfo.PCBType>
    let mechanicalSwitch: BehaviorRelay<KeyboardInfo.MechanicalSwitch>
    let capacitiveSwitch: BehaviorRelay<KeyboardInfo.CapacitiveSwitch>
    
    let keycapProfile: BehaviorRelay<KeycapInfo.KeycapProfile>
    let printingDirection: BehaviorRelay<KeycapInfo.PrintingDirection>
    let printingProcess: BehaviorRelay<KeycapInfo.PrintingProcess>
    let printingLanguage: BehaviorRelay<KeycapInfo.PrintingLanguage>
    
    let layoutRatio: BehaviorRelay<KeyboardAppearanceInfo.LayoutRatio>
    let keyboardDesign: BehaviorRelay<KeyboardAppearanceInfo.KeyboardDesign>
    let material: BehaviorRelay<KeyboardAppearanceInfo.Material>
    
    let createPostTapEvent: PublishRelay<[Data]>
    let leaveTapEvent: PublishRelay<Void>
    let toastCompleteEvent: PublishRelay<Void>
    
    init(
      title: BehaviorRelay<String> = .init(value: .defaultValue),
      content: BehaviorRelay<String> = .init(value: .defaultValue),
      regularPrice: BehaviorRelay<Int> = .init(value: .defaultValue),
      couponPrice: BehaviorRelay<Int> = .init(value: .defaultValue),
      discountPrice: BehaviorRelay<Int> = .init(value: .defaultValue),
      discountExpiry: BehaviorRelay<Date> = .init(value: .now),
      deliveryPrice: BehaviorRelay<DeliveryInfo.Price> = .init(value: .coalesce),
      deliverySchedule: BehaviorRelay<DeliveryInfo.Schedule> = .init(value: .coalesce),
      purpose: BehaviorRelay<KeyboardInfo.Purpose> = .init(value: .coalesce),
      inputMechanism: BehaviorRelay<KeyboardInfo.InputMechanism> = .init(value: .coalesce),
      connectionType: BehaviorRelay<KeyboardInfo.ConnectionType> = .init(value: .coalesce),
      powerSource: BehaviorRelay<KeyboardInfo.PowerSource> = .init(value: .coalesce),
      backlight: BehaviorRelay<KeyboardInfo.Backlight> = .init(value: .coalesce),
      pcbType: BehaviorRelay<KeyboardInfo.PCBType> = .init(value: .coalesce),
      mechanicalSwitch: BehaviorRelay<KeyboardInfo.MechanicalSwitch> = .init(value: .coalesce),
      capacitiveSwitch: BehaviorRelay<KeyboardInfo.CapacitiveSwitch> = .init(value: .coalesce),
      keycapProfile: BehaviorRelay<KeycapInfo.KeycapProfile> = .init(value: .coalesce),
      printingDirection: BehaviorRelay<KeycapInfo.PrintingDirection> = .init(value: .coalesce),
      printingProcess: BehaviorRelay<KeycapInfo.PrintingProcess> = .init(value: .coalesce),
      printingLanguage: BehaviorRelay<KeycapInfo.PrintingLanguage> = .init(value: .coalesce),
      layoutRatio: BehaviorRelay<KeyboardAppearanceInfo.LayoutRatio> = .init(value: .coalesce),
      keyboardDesign: BehaviorRelay<KeyboardAppearanceInfo.KeyboardDesign> = .init(value: .coalesce),
      material: BehaviorRelay<KeyboardAppearanceInfo.Material> = .init(value: .coalesce),
      createPostTapEvent: PublishRelay<[Data]> = .init(),
      leaveTapEvent: PublishRelay<Void> = .init(),
      toastCompleteEvent: PublishRelay<Void> = .init()
    ) {
      self.title = title
      self.content = content
      self.regularPrice = regularPrice
      self.couponPrice = couponPrice
      self.discountPrice = discountPrice
      self.discountExpiry = discountExpiry
      self.deliveryPrice = deliveryPrice
      self.deliverySchedule = deliverySchedule
      self.purpose = purpose
      self.inputMechanism = inputMechanism
      self.connectionType = connectionType
      self.powerSource = powerSource
      self.backlight = backlight
      self.mechanicalSwitch = mechanicalSwitch
      self.capacitiveSwitch = capacitiveSwitch
      self.pcbType = pcbType
      self.keycapProfile = keycapProfile
      self.printingDirection = printingDirection
      self.printingProcess = printingProcess
      self.printingLanguage = printingLanguage
      self.layoutRatio = layoutRatio
      self.keyboardDesign = keyboardDesign
      self.material = material
      self.createPostTapEvent = createPostTapEvent
      self.leaveTapEvent = leaveTapEvent
      self.toastCompleteEvent = toastCompleteEvent
    }
  }
  
  struct Output {
    let postCreatable: Driver<Bool>
    let isSuccessCreatePost: Driver<Bool>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ShoppingCoordinator?
  private let createPostUsecase: CreatePostUsecase
  
  // MARK: - Initializer
  init(
    createPostUsecase: CreatePostUsecase = CreatePostUsecaseImpl()
  ) {
    self.createPostUsecase = createPostUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let postCreatable = BehaviorRelay<Bool>(value: false)
    let isSuccessCreatePost = BehaviorRelay<Bool>(value: false)
    
    /// 상품 판매 게시글 작성
    input.createPostTapEvent
      .withUnretained(self)
      .flatMap { owner, files in
        let post = owner.makePost(input: input)
        
        return owner.createPostUsecase.execute(files: files, post: post)
          .catch {
            owner.coordinator?.showErrorAlert(error: $0)
            return .just(false)
          }
      }
      .bind(to: isSuccessCreatePost)
      .disposed(by: disposeBag)
      
    /// 나가기 이벤트 > 작성 중단 안내 팝업 표시
    input.leaveTapEvent
      .bind(with: self) { owner, _ in
        owner.showLeaveAlert()
      }
      .disposed(by: disposeBag)
    
    /// 토스트 완료 이벤트 > 작성 화면 나가기
    input.toastCompleteEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.pop()
      }
      .disposed(by: disposeBag)
    
    /// 작성 완료 버튼 활성화 여부 검사
    Observable.combineLatest(
      input.title,
      input.regularPrice,
      input.couponPrice,
      input.discountPrice
    )
    .map { $0.0.isFilled && $0.1 >= 0 && $0.2 >= 0 && $0.3 >= 0 }
    .bind(to: postCreatable)
    .disposed(by: disposeBag)
    
    return Output(
      postCreatable: postCreatable.asDriver(),
      isSuccessCreatePost: isSuccessCreatePost.asDriver()
    )
  }
}

extension CreateCommercialPostViewModel {
  
  private func makePost(input: Input) -> CommercialPost {
    
    let keyboardInfo = KeyboardInfo(
      purpose: input.purpose.value,
      inputMechanism: input.inputMechanism.value,
      connectionType: input.connectionType.value,
      powerSource: input.powerSource.value,
      backlight: input.backlight.value,
      pcbType: input.pcbType.value,
      mechanicalSwitch: input.mechanicalSwitch.value,
      capacitiveSwitch: input.capacitiveSwitch.value
    )
    
    let keycapInfo = KeycapInfo(
      profile: input.keycapProfile.value,
      direction: input.printingDirection.value,
      process: input.printingProcess.value,
      language: input.printingLanguage.value
    )
    
    let keyboardAppearanceInfo = KeyboardAppearanceInfo(
      ratio: input.layoutRatio.value,
      design: input.keyboardDesign.value,
      material: input.material.value,
      size: .init(width: .defaultValue, height: .defaultValue, depth: .defaultValue, weight: .defaultValue)
    )
    
    let keyboard = Keyboard(
      keyboardInfo: keyboardInfo,
      keycapInfo: keycapInfo,
      keyboardAppearanceInfo: keyboardAppearanceInfo
    )
    
    let commercialPrice = CommercialPrice(
      regularPrice: input.regularPrice.value,
      couponPrice: input.couponPrice.value,
      discountPrice: input.discountPrice.value,
      discountExpiryDate: input.discountExpiry.value
    )
    
    let deliveryInfo = DeliveryInfo(
      price: input.deliveryPrice.value,
      schedule: input.deliverySchedule.value
    )
    
    let commercialPost = CommercialPost(
      postID: .defaultValue, 
      postType: .keycat_commercialProduct,
      title: input.title.value,
      content: input.content.value,
      keyboard: keyboard,
      price: commercialPrice, 
      delivery: deliveryInfo,
      createdAt: .now,
      creator: .empty,
      files: [],
      bookmarks: [],
      shoppingCarts: [],
      hashTags: [],
      reviews: []
    )
    
    return commercialPost
  }
  
  private func showLeaveAlert() {
    coordinator?.showAlert(
      title: "작성 중단",
      message: "작성하신 내용이 모두 사라져요. 정말 중단하시겠어요?",
      okStyle: .destructive,
      isCancelable: true
    ) {
      self.coordinator?.pop()
    }
  }
}
