# 프로젝트

### 스크린샷

![Keycat_ReadME](https://github.com/wontaeyoung/KeyCat/assets/45925685/eedd303a-7e18-4a68-bd8c-cd4b1b1795c5)


<br><br>

### 한 줄 소개

키보드 상품 특화 커머스 플랫폼 앱

<br><br>

### 핵심 기능

- 로그인 / 회원가입 / 판매자 사업 권한 인증
- 상품 판매글 작성 / 조회 / 삭제 기능
- 상품 결제 기능
- 상품 리뷰 작성 / 조회 / 삭제 기능
- 북마크 / 장바구니
- 프로필 수정 기능
- 팔로우 기능

<br><br>

## 프로젝트 환경

**개발 인원**  
1인

<br>

**개발 기간**  
2024.04.10 ~ 2024.05.06 (3.5주)

<br>

## 개발 환경

**iOS 최소 버전**  
16.0+

<br>

**Xcode**  
15.3

<br><br>

## 아키텍처

<img width="2976" alt="Keycat_ReadME" src="https://github.com/wontaeyoung/KeyCat/assets/45925685/d547808e-b380-47da-8c05-3606ca069045">


<br><br>

## 기술 스택

- **`UIKit`** **`SnapKit`** **`UIHostingController`**

- **`RxSwift`** **`MVVM`** **`Coordinator`** **`Clean-Architecture`**

- **`RxAlamofire`** **`RequestInterceptor`** **`EventMonitor`**

- **`UserDefaults`** **`Kingfisher`** **`TabMan`** **`Toast`**


<br><br>

## 기술 활용

**RxSwift**

- 뷰 계층간 동일한 Subject 참조를 전달해서 변경에 대해 서버에 재요청하지 않고 UI 업데이트 동기화 처리

<br>

**UserDefaults**

- Property Wrapper를 활용해서 UserDefaults 접근에 대한 보일러 플레이트 코드 감소

<br>

**EventMonitor**

- HTTP 요청 / 응답 이벤트 생명주기에 대한 템플릿 로그를 작성하여 디버깅 및 유효성 검사에 활용

<br>

**RequestInterceptor**

- 액세스 토큰 만료 예외처리 로직을 Session에 주입하여 모든 HTTP 요청의 전처리 로직으로 적용되도록 구성

<br>

**Kingfisher**

- DownsamplingImageProcessor로 이미지 다운샘플링을 적용하여 상품 리스트 조회 화면의 메모리 사용량 33% 개선
- Downloader Configuration에 서버 이미지 요청에 필요한 액세스 토큰을 로그인 시점에 동기화하도록 설정

<br>

**UIHostingController**

- 홈 화면 레이아웃 구현에 더 적합한 SwiftUI를 호스팅하여 UIKit의 TabBar 구조에 주입

<br><br>

## 트러블슈팅

