//
//  ViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/9/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class ViewController: RxBaseViewController {
  
  // MARK: - UI
  private let 내용라벨 = UILabel().configured { $0.numberOfLines = 0 }
  private let 결과라벨 = UILabel().configured { $0.numberOfLines = 0 }
  private let 프로필이미지 = UIImageView().configured {
    $0.contentMode = .scaleAspectFit
  }
  
  private lazy var 스택 = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 5
    $0.alignment = .center
    
    for i in [사업자번호조회버튼, 프로필이미지, 포스트생성버튼, 특정포스트조회버튼, 로그인버튼, 댓글삭제버튼, 좋아요버튼, 팔로우버튼, 프로필조회버튼, 회원가입버튼] {
      $0.addArrangedSubview(i)
    }
  }
  
  private let 사업자번호조회버튼 = UIButton().configured {
    $0.configuration = .filled().applied {
      $0.title = "사업자번호조회버튼"
      $0.buttonSize = .large
      $0.cornerStyle = .large
    }
  }
  
  private let 포스트생성버튼 = UIButton().configured {
    $0.configuration = .filled().applied {
      $0.title = "포스트생성버튼"
      $0.buttonSize = .large
      $0.cornerStyle = .large
    }
  }
  
  private let 특정포스트조회버튼 = UIButton().configured {
    $0.configuration = .filled().applied {
      $0.title = "특정포스트조회버튼"
      $0.buttonSize = .large
      $0.cornerStyle = .large
    }
  }
  
  private let 로그인버튼 = UIButton().configured {
    $0.configuration = .filled().applied {
      $0.title = "로그인버튼"
      $0.buttonSize = .large
      $0.cornerStyle = .large
    }
  }
  
  private let 댓글삭제버튼 = UIButton().configured {
    $0.configuration = .filled().applied {
      $0.title = "댓글삭제버튼"
      $0.buttonSize = .large
      $0.cornerStyle = .large
    }
  }
  
  private let 좋아요버튼 = UIButton().configured {
    $0.configuration = .filled().applied {
      $0.title = "좋아요버튼"
      $0.buttonSize = .large
      $0.cornerStyle = .large
    }
  }
  
  private let 팔로우버튼 = UIButton().configured {
    $0.configuration = .filled().applied {
      $0.title = "팔로우버튼"
      $0.buttonSize = .large
      $0.cornerStyle = .large
    }
  }
  
  private let 프로필조회버튼 = UIButton().configured {
    $0.configuration = .filled().applied {
      $0.title = "프로필조회버튼"
      $0.buttonSize = .large
      $0.cornerStyle = .large
    }
  }
  
  private let 회원가입버튼 = UIButton().configured {
    $0.configuration = .filled().applied {
      $0.title = "회원가입버튼"
      $0.buttonSize = .large
      $0.cornerStyle = .large
    }
  }
  
  // MARK: - Property
  private let service = APIService()
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(내용라벨, 결과라벨, 스택)
  }
  
  override func setConstraint() {
    내용라벨.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.horizontalEdges.equalTo(view).inset(20)
    }
    
    결과라벨.snp.makeConstraints { make in
      make.top.equalTo(내용라벨.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(view).inset(20)
    }
    
    스택.snp.makeConstraints { make in
      make.top.equalTo(결과라벨.snp.bottom)
      make.horizontalEdges.equalTo(view).inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    사업자번호조회버튼.rx.tap
      .bind(with: self) { owner, _ in
        owner.fetchBusinessInfo()
      }
      .disposed(by: disposeBag)
    
    포스트생성버튼.rx.tap
      .bind(with: self) { owner, _ in
        owner.createPost()
      }
      .disposed(by: disposeBag)
    
    특정포스트조회버튼.rx.tap
      .bind(with: self) { owner, _ in
        owner.fetchSpecificPost()
      }
      .disposed(by: disposeBag)
    
    로그인버튼.rx.tap
      .bind(with: self) { owner, _ in
        owner.login()
      }
      .disposed(by: disposeBag)
    
    댓글삭제버튼.rx.tap
      .bind(with: self) { owner, _ in
        owner.deleteComment()
      }
      .disposed(by: disposeBag)
    
    좋아요버튼.rx.tap
      .bind(with: self) { owner, _ in
        owner.likePost()
      }
      .disposed(by: disposeBag)
    
    팔로우버튼.rx.tap
      .bind(with: self) { owner, _ in
        owner.follow()
      }
      .disposed(by: disposeBag)
    
    프로필조회버튼.rx.tap
      .bind(with: self) { owner, _ in
        owner.fetchMyProfile()
      }
      .disposed(by: disposeBag)
    
    회원가입버튼.rx.tap
      .bind(with: self) { owner, _ in
        owner.signUp()
      }
      .disposed(by: disposeBag)
  }
  
  var nextCursor: String = "0"
  let userID = "661e6adee8473868acf67c0c"
  let user2ID = "66205d47e8473868acf6af29"
  var postID = "6620d597e8473868acf6b64f"
  var commentID = ""
  
  // MARK: - Method
  private func fetchBusinessInfo() {
    let request = BusinessInfoRequest(b_no: "3749500872")
    let router = BusinessInfoRouter.fetchStatus(request: request)
    
    service.callRequest(with: router, of: BusinessInfoResponse.self)
      .subscribe(with: self) { owner, response in
        let businessInfo = UserMapper().toEntity(response.data.first!)
        
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = businessInfo.businessNumber + "\n" + businessInfo.businessStatus.rawValue
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func signUp() {
    let request = JoinRequest(email: "kez@gmail.com", password: "1", nick: "케즈", phoneNum: "010", birthDay: "1234")
    let router = AuthRouter.join(request: request)
    
    service.callRequest(with: router, of: AuthResponse.self)
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.email
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func login() {
    let request = LoginRequest(email: "kez@gmail.com", password: "1")
    let router = AuthRouter.login(request: request)
    
    service.callRequest(with: router, of: LoginResponse.self)
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.accessToken
        APITokenContainer.accessToken = response.accessToken
        APITokenContainer.refreshToken = response.refreshToken
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func fetchHashtagPosts() {
    let fetchPostQuery = SearchHashtagQuery(next: nextCursor, limit: "3", postType: .keycat_commercialProduct, hashTag: "키보드")
    let router = PostRouter.postsWithHashtagFetch(query: fetchPostQuery)
    
    service.callRequest(with: router, of: FetchPostsResponse.self)
      .do(onSuccess: { response in
        self.nextCursor = response.next_cursor
      })
      .map { $0.data.map { $0.title + $0.createdAt }}
      .map { $0.joined(separator: "\n") }
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func fetchOtherProfile() {
    let router = UserRouter.otherProfileFetch(userID: user2ID)
    
    service.callRequest(with: router, of: ProfileDTO.self)
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.nick
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func updateMyProfile() {
    
    let imageData = UIImage(named: "KeyCat_Opacity")?.jpegData(compressionQuality: 0.5)
    let request = UpdateMyProfileRequest(nick: nil, phoneNum: "1", birthDay: nil, profile: imageData)
    
    service.callUpdateProfileRequest(request: request)
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.email
        owner.프로필이미지.kf.setImage(with: URL(string: response.profileImage))
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func fetchMyProfile() {
    let router = UserRouter.myProfileFetch
    
    service.callRequest(with: router, of: ProfileDTO.self)
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.email
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func follow() {
    let router = UserRouter.follow(userID: user2ID)
    
    service.callRequest(with: router, of: FollowDTO.self)
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.nick + "/" + response.opponent_nick
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func fetchLikePosts() {
    let query = FetchLikePostsQuery(next: nextCursor, limit: "3")
    let router = LikeRouter.like2PostsFetch(query: query)
    
    service.callRequest(with: router, of: FetchPostsResponse.self)
      .do(onSuccess: { response in
        self.nextCursor = response.next_cursor
      })
      .map { $0.data.map { $0.title + $0.createdAt }}
      .map { $0.joined(separator: "\n") }
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func likePost() {
    let request = LikePostRequest(like_status: true)
    let router = LikeRouter.like(postID: fetchedPostID, request: request)
    
    service.callRequest(with: router, of: LikePostResponse.self)
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.like_status.description
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func deleteComment() {
    let router = CommentRouter.commentDelete(postID: postID, commentID: commentID)
    
    service.callReqeust(with: router)
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.description
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func updateComment() {
    let request = CommentRequest(content: "반갑습니다||5")
    let router = CommentRouter.commentUpdate(postID: postID, commentID: commentID, request: request)
    
    service.callRequest(with: router, of: CommentDTO.self)
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.content
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func createComment() {
    let request = CommentRequest(content: "안녕하세요||5")
    let router = CommentRouter.commentCreate(postID: postID, request: request)
    
    service.callRequest(with: router, of: CommentDTO.self)
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.content
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func fetchPostsFromUser() {
    let query = FetchPostsQuery(next: nextCursor, limit: "3", postType: .keycat_commercialProduct)
    let router = PostRouter.postsFromUserFetch(userID: userID, query: query)
    
    service.callRequest(with: router, of: FetchPostsResponse.self)
      .do(onSuccess: { response in
        self.nextCursor = response.next_cursor
      })
      .map { $0.data.map { $0.title + $0.createdAt }}
      .map { $0.joined(separator: "\n") }
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
    
  }
  
  private func deletePost() {
    
    let router = PostRouter.postDelete(id: "661f18cf438b876b25f75f3c")
    
    service.callReqeust(with: router)
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.description
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func fetchPosts() {
    
    let fetchPostQuery = FetchPostsQuery(next: nextCursor, limit: "3", postType: .keycat_commercialProduct)
    let router = PostRouter.postsFetch(query: fetchPostQuery)
    
    service.callRequest(with: router, of: FetchPostsResponse.self)
      .do(onSuccess: { response in
        self.nextCursor = response.next_cursor
      })
      .map { $0.data.map { $0.title + $0.createdAt }}
      .map { $0.joined(separator: "\n") }
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func updatePost() {
    let postID = "661f18d3438b876b25f75f5a"
    
    let request = PostRequest(title: "수정 컨텐츠")
    let postRouter = PostRouter.postUpdate(id: postID, request: request)
    
    service.callRequest(with: postRouter, of: PostDTO.self)
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.title
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  let mapper = PostMapper()
  
  var fetchedPostID: String = ""
  
  private func fetchSpecificPost() {
    let postRouter = PostRouter.specificPostFetch(id: postID)
    
    service.callRequest(with: postRouter, of: PostDTO.self)
      .subscribe(with: self) { owner, response in
        let entity = owner.mapper.toEntity(response)
        
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = entity!.content
        self.fetchedPostID = entity!.postID
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = "리프레시 토큰이 만료되었습니다"
      }
      .disposed(by: disposeBag)
  }
  
  private func uploadImageAndCreatePost() {
    
    let images: [UIImage] = []
    let data: [Data] = images.compactMap { $0.pngData() }
    
    service.callImageUploadRequest(data: data)
      .map { $0.files }
      .flatMap {
        let request = PostRequest(
          title: "타이틀", content: "컨텐츠", content1: "컨텐츠1", content2: "컨텐츠2", content3: "컨텐츠3", content4: "컨텐츠4", content5: nil, product_id: PostType.keycat_commercialProduct.productID, files: $0)
        let postRouter = PostRouter.postCreate(request: request)
        
        return self.service.callRequest(with: postRouter, of: PostDTO.self)
      }
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.content
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
      
  }
  
  private func createPost() {
    
    let random = Int.random(in: 100...999)
    
    let keyboard = Keyboard(
      keyboardInfo: KeyboardInfo(
        purpose: .gaming,
        inputMechanism: .mechanical,
        connectionType: .bluetooth,
        powerSource: .battery,
        backlight: .withBacklight,
        mechanicalSwitch: .clicky,
        capacitiveSwitch: .none,
        pcbType: .hotSwap
      ),
      keycapInfo: KeycapInfo(
        profile: .cherry,
        direction: .top,
        process: .doubleShot,
        language: .koreanEnglish
      ),
      keyboardAppearanceInfo: KeyboardAppearanceInfo(
        ratio: .eighty,
        design: .standard,
        material: .aluminum,
        size: .init(width: 400, height: 200, depth: 15, weight: 708)
      )
    )
    
    let keyboardDTO = KeyboardDTO(
      keyboardInfo: keyboard.keyboardInfo.raws,
      keycapInfo: keyboard.keycapInfo.raws,
      appearanceInfo: keyboard.keyboardAppearanceInfo.raws
    )
    
    let commercialPrice = CommercialPrice(regularPrice: 15000, couponPrice: 3000, discountPrice: 4000, discountExpiryDate: Calendar.current.date(byAdding: .day, value: 3, to: .now))
    
    let commercialPriceDTO = CommercialPriceDTO(
      regularPrice: commercialPrice.regularPrice,
      couponPrice: commercialPrice.couponPrice,
      discountPrice: commercialPrice.discountPrice,
      discountExpiryDate: DateManager.shared.dateToIsoString(with: commercialPrice.discountExpiryDate)
    )
    
    let deliveryInfo = DeliveryInfo(price: .paid, schedule: .nextDay)
    
    let deliveryInfoDTO = DeliveryInfoDTO(price: deliveryInfo.price.rawValue, schedule: deliveryInfo.schedule.rawValue)
    
    let keyboardString = try! JsonCoder.shared.encodeString(from: keyboardDTO)
    let commercialPriceString = try! JsonCoder.shared.encodeString(from: commercialPriceDTO)
    let deliveryInfoString = try! JsonCoder.shared.encodeString(from: deliveryInfoDTO)
    
    let request = PostRequest(
      title: "안녕하세요 키보드 판매합니다", 
      content: "키보드 최고 #키보드 #마우스",
      content1: keyboardString,
      content2: commercialPriceString,
      content3: deliveryInfoString,
      content4: "컨텐츠\(random)", 
      content5: nil,
      product_id: PostType.keycat_commercialProduct.productID,
      files: nil
    )
    
    let postRouter = PostRouter.postCreate(request: request)
    
    service.callRequest(with: postRouter, of: PostDTO.self)
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.content
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
}
