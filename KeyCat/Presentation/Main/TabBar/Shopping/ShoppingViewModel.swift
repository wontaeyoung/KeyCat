//
//  ShoppingViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 4/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let viewDidLoadEvent: PublishRelay<Void>
    let createPostTapEvent: PublishRelay<Void>
    
    init(
      viewDidLoadEvent: PublishRelay<Void> = .init(),
      createPostTapEvent: PublishRelay<Void> = .init()
    ) {
      self.viewDidLoadEvent = viewDidLoadEvent
      self.createPostTapEvent = createPostTapEvent
    }
  }
  
  struct Output {
    let hasSellerAuthority: Driver<Bool>
    let commercialPosts: Driver<[CommercialPost]>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ShoppingCoordinator?
  
  // MARK: - Initializer
  init() {
    
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let hasSellerAuthority = PublishRelay<Bool>()
    let commercialPosts = PublishRelay<[CommercialPost]>()
    
    input.viewDidLoadEvent
      .map { UserInfoService.hasSellerAuthority }
      .bind(to: hasSellerAuthority)
      .disposed(by: disposeBag)
    
    input.viewDidLoadEvent
      .map { self.makeDummyPosts() }
      .bind(to: commercialPosts)
      .disposed(by: disposeBag)
    
    input.createPostTapEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.showCreatePostView()
      }
      .disposed(by: disposeBag)
    
    return Output(
      hasSellerAuthority: hasSellerAuthority.asDriver(onErrorJustReturn: false),
      commercialPosts: commercialPosts.asDriver(onErrorJustReturn: [])
    )
  }
  
  private func makeDummyPosts() -> [CommercialPost] {
    print("시작", Date.now)
    let posts: [CommercialPost] = (1...20).map { n in
        CommercialPost(
          postID: n.description,
          postType: .keycat_commercialProduct,
          title: "키보드 상품 타이틀 \(n)",
          content: "상품 설명입니다 \(n)",
          keyboard: .init(
            keyboardInfo: .init(
              purpose: .allCases.randomElement()!,
              inputMechanism: .allCases.randomElement()!,
              connectionType: .allCases.randomElement()!,
              powerSource: .allCases.randomElement()!,
              backlight: .allCases.randomElement()!,
              pcbType: .allCases.randomElement()!,
              mechanicalSwitch: .allCases.randomElement()!,
              capacitiveSwitch: .allCases.randomElement()!
            ),
            keycapInfo: .init(
              profile: .allCases.randomElement()!,
              direction: .allCases.randomElement()!,
              process: .allCases.randomElement()!,
              language: .allCases.randomElement()!
            ),
            keyboardAppearanceInfo: .init(
              ratio: .allCases.randomElement()!,
              design: .allCases.randomElement()!,
              material: .allCases.randomElement()!,
              size: .init(width: 380, height: 150, depth: 40, weight: 1062)
            )
          ),
          price: .init(
            regularPrice: n * 1000,
            couponPrice: [0, 1000].randomElement()!,
            discountPrice: [0, 250, 500].randomElement()! * n,
            discountExpiryDate: DateManager.shared.date(from: .now, as: .day, by: n)
          ),
          delivery: .init(
            price: .allCases.randomElement()!,
            schedule: .allCases.randomElement()!
          ),
          createdAt: DateManager.shared.date(from: .now, as: .hour, by: n),
          creator: .init(
            userID: n.description,
            nickname: "닉네임 \(n)",
            profileImageURLString: ""
          ),
          files: ["uploads/posts/vamillo_1_1714571161018.jpg"],
          likes: [["662a499ea8bf9f5c9ca667a8"], []].randomElement()!,
          shoppingCarts: [["662a499ea8bf9f5c9ca667a8"], []].randomElement()!,
          hashTags: [],
          reviews: [
            .init(
              reviewID: n.description,
              content: "리뷰 \(n)",
              rating: .allCases.randomElement()!,
              createdAt: DateManager.shared.date(from: .now, as: .hour, by: n),
              creator: .init(
                userID: n.description,
                nickname: "닉네임 \(n+1)",
                profileImageURLString: ""
              )
            )
          ]
        )
    }
    print("종료", Date.now)
    return posts
  }
}
