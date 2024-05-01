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
      leaveTapEvent: PublishRelay<Void> = .init()
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
  
  private func makePost() -> CommercialPost {
    
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
