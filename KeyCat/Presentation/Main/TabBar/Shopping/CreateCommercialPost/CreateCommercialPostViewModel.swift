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
    let title: PublishRelay<String>
    let content: PublishRelay<String>
    let images: PublishRelay<[Data]>
    
    let regularPrice: PublishRelay<Int>
    let couponPrice: PublishRelay<Int>
    let discountPrice: PublishRelay<Int>
    let discountExpiry: PublishRelay<Date>
    
    let deliveryPrice: PublishRelay<DeliveryInfo.Price>
    let deliverySchedule: PublishRelay<DeliveryInfo.Schedule>
    
    let purpose: PublishRelay<KeyboardInfo.Purpose>
    let inputMechanism: PublishRelay<KeyboardInfo.InputMechanism>
    let connectionType: PublishRelay<KeyboardInfo.ConnectionType>
    let powerSource: PublishRelay<KeyboardInfo.PowerSource>
    let backlight: PublishRelay<KeyboardInfo.Backlight>
    let pcbType: PublishRelay<KeyboardInfo.PCBType>
    let mechanicalSwitch: PublishRelay<KeyboardInfo.MechanicalSwitch>
    let capacitiveSwitch: PublishRelay<KeyboardInfo.CapacitiveSwitch>
    
    let keycapProfile: PublishRelay<KeycapInfo.KeycapProfile>
    let printingDirection: PublishRelay<KeycapInfo.PrintingDirection>
    let printingProcess: PublishRelay<KeycapInfo.PrintingProcess>
    let printingLanguage: PublishRelay<KeycapInfo.PrintingLanguage>
    
    let layoutRatio: PublishRelay<KeyboardAppearanceInfo.LayoutRatio>
    let keyboardDesign: PublishRelay<KeyboardAppearanceInfo.KeyboardDesign>
    let material: PublishRelay<KeyboardAppearanceInfo.Material>
    
    let createPostTapEvent: PublishRelay<Void>
    let leaveTapEvent: PublishRelay<Void>
    
    init(
      title: PublishRelay<String> = .init(),
      content: PublishRelay<String> = .init(),
      images: PublishRelay<[Data]> = .init(),
      regularPrice: PublishRelay<Int> = .init(),
      couponPrice: PublishRelay<Int> = .init(),
      discountPrice: PublishRelay<Int> = .init(),
      discountExpiry: PublishRelay<Date> = .init(),
      deliveryPrice: PublishRelay<DeliveryInfo.Price> = .init(),
      deliverySchedule: PublishRelay<DeliveryInfo.Schedule> = .init(),
      purpose: PublishRelay<KeyboardInfo.Purpose> = .init(),
      inputMechanism: PublishRelay<KeyboardInfo.InputMechanism> = .init(),
      connectionType: PublishRelay<KeyboardInfo.ConnectionType> = .init(),
      powerSource: PublishRelay<KeyboardInfo.PowerSource> = .init(),
      backlight: PublishRelay<KeyboardInfo.Backlight> = .init(),
      pcbType: PublishRelay<KeyboardInfo.PCBType> = .init(),
      mechanicalSwitch: PublishRelay<KeyboardInfo.MechanicalSwitch> = .init(),
      capacitiveSwitch: PublishRelay<KeyboardInfo.CapacitiveSwitch> = .init(),
      keycapProfile: PublishRelay<KeycapInfo.KeycapProfile> = .init(),
      printingDirection: PublishRelay<KeycapInfo.PrintingDirection> = .init(),
      printingProcess: PublishRelay<KeycapInfo.PrintingProcess> = .init(),
      printingLanguage: PublishRelay<KeycapInfo.PrintingLanguage> = .init(),
      layoutRatio: PublishRelay<KeyboardAppearanceInfo.LayoutRatio> = .init(),
      keyboardDesign: PublishRelay<KeyboardAppearanceInfo.KeyboardDesign> = .init(),
      material: PublishRelay<KeyboardAppearanceInfo.Material> = .init(),
      createPostTapEvent: PublishRelay<Void> = .init(),
      leaveTapEvent: PublishRelay<Void> = .init()
    ) {
      self.title = title
      self.content = content
      self.images = images
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
    }
  }
  
  struct Output {
    let postCreatable: Driver<Bool>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ShoppingCoordinator?
  
  // MARK: - Initializer
  init() {
    
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let postCreatable = BehaviorRelay<Bool>(value: false)
    
    /// 나가기 이벤트 > 작성 중단 안내 팝업 표시
    input.leaveTapEvent
      .bind(with: self) { owner, _ in
        owner.showLeaveAlert()
      }
      .disposed(by: disposeBag)
    
    Observable.combineLatest(
      input.title,
      input.regularPrice,
      input.couponPrice,
      input.discountPrice
    )
    .map {
      $0.0.isEmpty == false && $0.1 >= 0 && $0.2 >= 0 && $0.3 >= 0
    }
    .bind(to: postCreatable)
    .disposed(by: disposeBag)
    
    return Output(
      postCreatable: postCreatable.asDriver()
    )
  }
}

extension CreateCommercialPostViewModel {
  
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
