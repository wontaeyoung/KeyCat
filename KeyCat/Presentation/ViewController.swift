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
    
    for i in [포스트수정버튼, 프로필이미지, 포스트생성버튼, 특정포스트조회버튼, 로그인버튼, 댓글삭제버튼, 좋아요버튼, 팔로우버튼, 프로필조회버튼, 회원가입버튼] {
      $0.addArrangedSubview(i)
    }
  }
  
  private let 포스트수정버튼 = UIButton().configured {
    $0.configuration = .filled().applied {
      $0.title = "포스트수정버튼"
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
    포스트수정버튼.rx.tap
      .bind(with: self) { owner, _ in
        owner.updatePost()
      }
      .disposed(by: disposeBag)
    
    포스트생성버튼.rx.tap
      .bind(with: self) { owner, _ in
        owner.createPost2()
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
  let posts: [CommercialPost] = (1...100).map { n in
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
          discountPrice: [150, 300, 450, 500, 600, 900].randomElement()! * n,
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
        bookmarks: [["662a499ea8bf9f5c9ca667a8"], []].randomElement()!,
        shoppingCarts: [["662a499ea8bf9f5c9ca667a8"], []].randomElement()!,
        hashTags: [],
        reviews: (1...5).map { i in
            .init(
              reviewID: n.description,
              content: "리뷰 \(n)",
              rating: .allCases.randomElement()!,
              createdAt: DateManager.shared.date(from: .now, as: .hour, by: n),
              creator: .init(
                userID: n.description,
                nickname: "닉네임 \(n*i)",
                profileImageURLString: ""
              )
            )
        }
      )
  }
  
  var postIndex: Int = 0
  
  
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
    SignInUsecaseImpl().execute(email: "q@keycat.com", password: "123@")
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
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
  
  var newPosts: [String] = [
    "663210adea1f6976de7dcf9b",
    "66321794ea1f6976de7dd273",
    "663285eadb7c7876aa97fa58",
    "663285fbea1f6976de7e35bb",
    "663285fcdb7c7876aa97fa62",
    "663285feea1f6976de7e35c5",
    "663285ffdb7c7876aa97fa6c",
    "66328600ea1f6976de7e35cf",
    "66328600db7c7876aa97fa76",
    "66328601ea1f6976de7e35d9",
    "66328602db7c7876aa97fa80",
    "66328603ea1f6976de7e35e3",
    "66328604db7c7876aa97fa8a",
    "66328605ea1f6976de7e35ed",
    "66328606db7c7876aa97fa94",
    "66328607ea1f6976de7e35f7",
    "66328608db7c7876aa97fa9e",
    "66328609ea1f6976de7e3601",
    "6632860adb7c7876aa97faa8",
    "6632860aea1f6976de7e360b",
    "6632860bdb7c7876aa97fab2",
    "6632860cea1f6976de7e3615",
    "6632860ddb7c7876aa97fabc",
    "6632860fea1f6976de7e361f",
    "66328610db7c7876aa97fac6",
    "66328610db7c7876aa97fad0",
    "66328611ea1f6976de7e3631",
    "66328612db7c7876aa97fada",
    "66328613ea1f6976de7e363b",
    "66328614db7c7876aa97fae4",
    "66328614ea1f6976de7e3645",
    "66328615ea1f6976de7e364f",
    "66328616ea1f6976de7e3659",
    "66328617db7c7876aa97faf7",
    "66328618db7c7876aa97fb01",
    "66328618ea1f6976de7e366d",
    "66328619db7c7876aa97fb0e",
    "66328619ea1f6976de7e367a",
    "6632861adb7c7876aa97fb18",
    "6632861bea1f6976de7e3684",
    "6632861bdb7c7876aa97fb25",
    "6632861cea1f6976de7e3691",
    "6632861cdb7c7876aa97fb2f",
    "6632861ddb7c7876aa97fb3c",
    "6632861eea1f6976de7e36a2",
    "6632861edb7c7876aa97fb49",
    "6632861fea1f6976de7e36b4",
    "6632861fdb7c7876aa97fb56",
    "66328620ea1f6976de7e36c1",
    "66328621db7c7876aa97fb60",
    "66328621ea1f6976de7e36ce",
    "66328622db7c7876aa97fb6d",
    "66328622ea1f6976de7e36d8",
    "66328623db7c7876aa97fb77",
    "66328624ea1f6976de7e36e2",
    "66328624db7c7876aa97fb81",
    "66328625ea1f6976de7e36ec",
    "66328625db7c7876aa97fb8b",
    "66328626ea1f6976de7e36f6",
    "66328627db7c7876aa97fb95",
    "66328627ea1f6976de7e3700",
    "66328628db7c7876aa97fb9f",
    "66328628ea1f6976de7e370a",
    "66328629ea1f6976de7e3714",
    "6632862aea1f6976de7e371e",
    "6632862adb7c7876aa97fbb2",
    "6632862bdb7c7876aa97fbc5",
    "6632862bea1f6976de7e372b",
    "6632862cdb7c7876aa97fbcf",
    "6632862dea1f6976de7e3735",
    "6632862ddb7c7876aa97fbdd",
    "6632862eea1f6976de7e3743",
    "6632862fdb7c7876aa97fbe7",
    "6632862fea1f6976de7e374d",
    "66328630db7c7876aa97fbf1",
    "66328630ea1f6976de7e3757",
    "66328631db7c7876aa97fbfb",
    "66328632ea1f6976de7e3761",
    "66328632db7c7876aa97fc05",
    "66328633ea1f6976de7e376b",
    "66328633db7c7876aa97fc0f",
    "66328634ea1f6976de7e3775",
    "66328635ea1f6976de7e377f",
    "66328635db7c7876aa97fc21",
    "66328636ea1f6976de7e3789",
    "66328637db7c7876aa97fc2b",
    "66328637ea1f6976de7e3793",
    "66328638db7c7876aa97fc35",
    "66328638ea1f6976de7e379d",
    "66328639db7c7876aa97fc3f",
    "6632863aea1f6976de7e37a7",
    "6632863adb7c7876aa97fc49",
    "6632863bea1f6976de7e37b1",
    "6632863bdb7c7876aa97fc53",
    "6632863cea1f6976de7e37bb",
    "6632863ddb7c7876aa97fc5d",
    "6632863dea1f6976de7e37c5",
    "6632863edb7c7876aa97fc67",
    "6632863eea1f6976de7e37cf",
    "6632863fdb7c7876aa97fc71",
    "66328640ea1f6976de7e37d9",
    "66328641db7c7876aa97fc7b"
  ]
  
  
  private func fetchPosts() {
    
    let fetchPostQuery = FetchPostsQuery(next: "", limit: "200", postType: .keycat_commercialProduct)
    let router = PostRouter.postsFetch(query: fetchPostQuery)
    
    service.callRequest(with: router, of: FetchPostsResponse.self)
      .subscribe(with: self) { owner, response in
        owner.결과라벨.text = "요청 성공"
        owner.내용라벨.text = response.next_cursor
      } onFailure: { owner, error in
        owner.결과라벨.text = "요청 실패"
        owner.내용라벨.text = error.localizedDescription
      }
      .disposed(by: disposeBag)
  }
  
  private func updatePost() {
    let postID = newPosts[postIndex]
    postIndex += 1
    
    let request = PostRequest(files: [
      "uploads/posts/keyboard1_1714639591607.jpg",
      "uploads/posts/keyboard2_1714639591628.jpg",
      "uploads/posts/keyboard3_1714639591630.png"
    ])
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
  
  private func createPost2() {
    
    let usecase = CreatePostUsecaseImpl()
    
    usecase.execute(files: [], post: posts[postIndex])
      .subscribe(with: self) { owner, success in
        print(success)
      } onFailure: { owner, error in
        print(error.localizedDescription)
      }
      .disposed(by: disposeBag)

    postIndex += 1
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
        pcbType: .hotSwap, 
        mechanicalSwitch: .clicky,
        capacitiveSwitch: .none
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
