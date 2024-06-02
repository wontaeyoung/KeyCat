# 프로젝트

### 스크린샷

![Keycat_리드미 스크린샷1](https://github.com/wontaeyoung/KeyCat/assets/45925685/03e22cad-7fe6-408f-bb34-6a78dccc75d6)

![Keycat_리드미 스크린샷2](https://github.com/wontaeyoung/KeyCat/assets/45925685/bc4f3ec7-c9ca-49e3-9c57-355e87266a87)

### 한 줄 소개

키보드 상품 특화 커머스 플랫폼 앱

<br>

### 서비스 기능

- 로그인 / 회원가입 / 판매자 사업 권한 인증
- 상품 판매글 작성 / 조회 / 삭제 기능
- 상품 이미지 업로드 기능
- PG사 연동 상품 결제 기능
- 상품 리뷰 작성 / 조회 / 삭제 기능
- 북마크 / 장바구니
- 프로필 수정 기능
- 팔로우 기능

<br>

## 프로젝트 환경

**개발 인원**  
iOS/기획/디자인 1인(본인)  
Backend 1인

**개발 기간**  
2024.04.10 ~ 2024.05.06 (3.5주)

<br>

## 개발 환경

**iOS 최소 버전**  
16.0+

**Xcode**  
15.3

<br>

## 기술 스택

- **`UIKit`** **`SnapKit`** **`UIHostingController`**

- **`RxSwift`** **`Input&Output`** **`MVVM`** **`Coordinator`** **`Clean-Architecture`**

- **`RxAlamofire`** **`RequestInterceptor`** **`EventMonitor`**

- **`UserDefaults`** **`Kingfisher`** **`TabMan`** **`Toast`**

<br>

## 구현 고려사항
- 디자인 시스템으로 **UI 일관성** 유지
- 공통 로직 재사용을 위한 **프로토콜**과 **상속** 활용
- Rx 옵저버블의 참조성과 바인딩을 활용하여 뷰 계층간 데이터 **동기화**
- Input&Output 패턴으로 **단방향 데이터 흐름** 구성
- 네트워크 단절 및 에러 상황에 대한 **사용자 안내** UI 표시 처리
- 디바이스 사이즈 기반 이미지 리사이징으로 **메모리 최적화**

<br>

## 아키텍처

![image](https://github.com/wontaeyoung/KeyCat/assets/45925685/ded0d561-550d-43cc-9a8d-e96b26c782e3)

<br>

## 기술 활용

### 상품 조회 커서 기반 페이지네이션 적용

- 커머스 플랫폼 상품은 데이터 추가가 빈번하게 발생하고, 페이지 번호 기반 탐색이 필요하지 않다고 판단하여 **커서 기반 페이지네이션**을 채택했습니다.

- 스크롤 동작으로 인한 API 중복 호출 트리거를 방지하기 위해, 1초의 **쓰로틀링**을 적용하였습니다.

<br>

### HTTP Error -> 도메인 Error 매핑 과정

- API 응답에서 발생하는 HTTP 상태코드를 도메인 에러로 매핑하는 로직을 구성했습니다.

- 에러 매핑 로직을 프로토콜에 공통 구현하고 필요한 Repository에 채택하여 재사용했습니다.

<br>

<details open>

  <summary>에러 매핑 플로우</summary>
  
<img src="https://github.com/wontaeyoung/KeyCat/assets/45925685/37aedd0a-00d3-484a-be5f-c9b0271be020" width="700">

</details>

<br>

<details open>

  <summary>레포지토리 주입 예시</summary>

<img src="https://github.com/wontaeyoung/KeyCat/assets/45925685/42ba7086-ce2e-4ce3-99d5-9700db8d60d8" width="500">

</details>

<br>

### Router 관리

- **`URLRequestConvertible`** 프로토콜을 구현하는 Router 프로토콜을 정의해서 API Endpoint를 관리했습니다.

<img src="https://github.com/wontaeyoung/KeyCat/assets/45925685/6fbf73fa-b2c4-44bf-91a7-a6121bb20bc3" width = 300>

<br>

<img src="https://github.com/wontaeyoung/KeyCat/assets/45925685/28dfc66c-fb53-41b0-b07f-84dee48d76d5" width = 400>

<br>

<img src="https://github.com/wontaeyoung/KeyCat/assets/45925685/c5710792-f55e-487e-8c8d-f3828aff745c" width = 500>

<br>
<br>

### 액세스 토큰 자동 갱신을 위한 Request Interceptor 구현

- 액세스 토큰 만료 시 자동으로 토큰을 갱신하고, 갱신된 토큰을 사용하여 이전에 실패한 API 요청을 자동으로 재수행하는 로직을 **`Request Interceptor`** 에 구현했습니다.

- AF Session에 Interceptor를 주입해서, 모든 API 요청에 토큰 관리 및 재요청 로직이 자동으로 적용됩니다.

<br>

<details>

  <summary>소스코드</summary>
  
```swift
final class APIRequestInterceptor: RequestInterceptor {
  
  func adapt(
    _ urlRequest: URLRequest,
    for session: Session,
    completion: @escaping (Result<URLRequest, any Error>) -> Void
  ) {
    
    /// 로그인 요청은 Intercept 하지 않고 바로 실행
    guard
      let urlString = urlRequest.url?.absoluteString,
      urlString.hasPrefix(APIKey.baseURL),
      UserInfoService.hasSignInLog
    else {
      completion(.success(urlRequest))
      return
    }
    
    /// 갱신된 토큰으로 Header 재설정
    let urlRequest = urlRequest.applied {
      $0.setValue(UserInfoService.accessToken, forHTTPHeaderField: KCHeader.Key.authorization)
    }
    
    completion(.success(urlRequest))
  }
  
  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: any Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    
    /// 에러 케이스가 419면 토큰 리프레시, 아니면 함수 종료
    guard 
      let statusCode = request.response?.statusCode,
      statusCode == HTTPStatusError.accessTokenExpired.statusCode
    else {
      return completion(.doNotRetry)
    }
      
    /// 토큰 리프레시 요청
    AF.request(AuthRouter.tokenRefresh)
      .validate()
      .responseDecodable(of: RefreshTokenResponse.self) { response in
        
        switch response.result {
            /// 응답 토큰으로 갱신 후 기존 API 재요청
          case .success(let tokenResponse):
            UserInfoService.renewAccessToken(with: tokenResponse.accessToken)
            completion(.retry)
            
            /// 리프레시 토큰이 만료되면 로그인 화면으로 돌아가도록 에러 방출
          case .failure:
            completion(.doNotRetryWithError(HTTPStatusError.refreshTokenExpired))
        }
      }
  }
}
```
</details>

<br>

### HTTP 이벤트 모니터링 로직 구현
  
- **`API EventMonitor`** 를 구현하여 HTTP 라이프사이클에 대한 로깅 프로세스를 추가했습니다.

- HTTP 요청 및 응답 과정을 구조화된 로그 메시지로 변환하여 디버깅에 활용했습니다.

<br>
 
<details open>
  
  <summary>소스코드 예시</summary>
    
  <img src="https://github.com/wontaeyoung/KeyCat/assets/45925685/2791f819-81c2-4ac0-8c45-cb222ae243b3" width="500">

</details>

<br>

<details open>
  
  <summary>콘솔 로그 예시</summary>
    
  <img src="https://github.com/wontaeyoung/KeyCat/assets/45925685/fd4536f1-f616-4130-b01f-64ccda2da966" width="500">

  <img src="https://github.com/wontaeyoung/KeyCat/assets/45925685/ae20a891-1229-4ee7-a342-94f49ffc1da4" width="500">

</details>

<br>

### 커스텀 UI 컴포넌트 설계
  
- 기능이 포함된 커스텀 UI 컴포넌트를 활용해서 로직 재사용성 및 UI 일관성을 확보했습니다.

<br>
  
<details open>
  
  <summary>커스텀 UI 컴포넌트 예시</summary>

<img src="https://github.com/wontaeyoung/KeyCat/assets/45925685/6dd1ca77-aef3-4577-a44b-2eed4a1fe5ce" width="600">

</details>

<br>

## 트러블슈팅

### 상품 이미지 메모리 최적화

- 상품 목록을 조회하는 UI에서 고해상도의 원본 이미지를 로딩함에 따라 메모리 사용량이 증가하는 문제를 경험했습니다.
- Kingfisher 라이브러리의 **`DownsamplingImageProcessor`** 기능을 활용하여, 디스플레이 해상도 기반으로 다운샘플링을 적용하여 메모리 사용량을 **약 61.3%** 개선했습니다.

<br>

<img src="https://github.com/wontaeyoung/KeyCat/assets/45925685/07c59e89-3b8e-431e-a1d2-99b2a64a95ad" width="500">

<br>
<br>

### 네트워크 상태 인터페이스 처리 문제

- 네트워크 연결 상태 변동 시 UI에 상태 안내를 표시하기 위하여, **`NWPathMonitor`** 를 활용해 네트워크 상태를 모니터링하고 모든 VC가 상속받는 Base VC 내에 상태 표시 로직을 구현하였습니다.

- **`addSubview`** 를 사용하여 현재 뷰 계층의 가장 하위에 안내 UI를 추가하려 했으나 의도와 달리 UI가 화면을 완전히 가리지 못하고, Base VC를 상속받은 모든 뷰 인스턴스에 중복으로 추가되는 문제가 발생하였습니다.

<img src="https://github.com/wontaeyoung/KeyCat/assets/45925685/83a24b64-4049-42ad-89b6-b04aa91165b0" width="500">

<br><br>

**UIWindow를 이용한 개선**

- 이 문제를 해결하기 위해 **`UIWindow`** 를 활용하는 구조로 변경하였습니다.

- SceneDelegate에서 네트워크 상태 변경 이벤트를 감지하여 메인 Window보다 상위 레벨인 ErrorWindow를 추가하는 방식으로 UI를 구현하고, 네트워크 상태가 정상으로 돌아오면 원래 화면을 재개하는 로직을 적용했습니다.

- Scene의 연결 / 끊김 생명주기 이벤트에 모니터링 로직을 연동하여, 모니터링 리소스가 회수되도록 설정했습니다.

<img src="https://github.com/wontaeyoung/KeyCat/assets/45925685/526b1f0c-bd53-4429-ab57-8d7fd6623db1" width="250">

<br><br>

<details>
  
  <summary> 모니터링 소스코드 </summary>

    
```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  ...
    
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    ...
    
    startMonitoring(scene: scene)
  }
  
  private func startMonitoring(scene: UIScene) {
    NetworkMonitor.shared.start { [weak self] path in
      guard let self else { return }
      
      switch path.status {
        case .satisfied:
          setErrorWindowOff(scene: scene)
        default:
          setErrorWindowOn(scene: scene)
      }
    }
  }
  
  private func setErrorWindowOn(scene: UIScene) {
    guard let windowScene = scene as? UIWindowScene else { return }
    
    self.errorWindow = UIWindow(windowScene: windowScene).configured {
      $0.windowLevel = .statusBar
      $0.addSubview(NetworkUnsatisfiedView(frame: $0.bounds))
      $0.makeKeyAndVisible()
    }
  }
  
  private func setErrorWindowOff(scene: UIScene) {
    errorWindow?.resignKey()
    errorWindow = nil
  }
    
  ...
  
}
```
</details>

<br><br>
