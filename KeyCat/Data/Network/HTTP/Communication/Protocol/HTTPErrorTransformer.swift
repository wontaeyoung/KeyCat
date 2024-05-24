//
//  HTTPErrorTransformer.swift
//  KeyCat
//
//  Created by 원태영 on 4/21/24.
//

/// Repository에 에러 핸들링 기능을 주입하기 위한 프로토콜
protocol HTTPErrorTransformer {
  
  func httpErrorToDomain(from error: any Error, domain: HTTPRequestDomain) -> KCError
}

extension HTTPErrorTransformer {
  
  /// HTTPError -> HTTPStatusError -> Domain Error 변환
  func httpErrorToDomain(from error: any Error, domain: HTTPRequestDomain) -> KCError {
    
    /// HTTPError로 캐스팅이 실패하면 unknown 리턴
    guard let httpError = error as? HTTPError else {
      return .unknown
    }
    
    /// HTTP Error 체크
    switch httpError {
        
        /// 요청이 실패해서 상태코드 없이 실패한 케이스 (인터넷 상태, URL 문제 등)
      case .requestFailed:
        return .retrySignIn
        
        /// 상태코드가 있는 케이스
      case .unexceptedResponse(let status):
        return handleStatusCode(status: status, domain: domain)
    }
  }
  
  private func handleStatusCode(status: HTTPError.HTTPStatus, domain: HTTPRequestDomain) -> KCError {
    
    /// 상태 코드를 통해서 HTTPStatusError 초기화
    let httpStatusError = status.toHTTPStatusError
    
    /// 상태코드 에러 체크
    switch httpStatusError {
        
        /// 401 케이스 분석
      case .accessFailed:
        
        /// API 요청 도메인에 따라 다른 accessFailed 케이스로 리턴
        switch domain {
          case .signIn:
            return .accessFailed(detail: .login)
            
          case .accessToken, .withdraw,
              .createPost, .fetchPosts, .deletePost, .likePost,
              .createReview, .deleteReview,
              .follow, .unfollow,
              .paymentValidation,
              .createChatRoom, .fetchMyChatRooms, .fetchChats, .sendChat:
            return .accessFailed(detail: .accessToken)
            
          default:
            return httpStatusError.toDomain
        }
        
        /// 409 케이스 분석
      case .conflict:
        
        /// API 요청 도메인에 따라 다른 conflict 케이스로 리턴
        switch domain {
          case .emailValidation:
            return .conflict(detail: .emailDuplicated)
            
          case .signUp:
            return .conflict(detail: .registeredUser)
            
          case .follow:
            return .conflict(detail: .follow)
            
          default:
            return httpStatusError.toDomain
        }
        
        /// 410 케이스 분석
      case .targetNotFound:
        
        /// API 요청 도메인에 따라 다른 targetNotFound 케이스로 리턴
        switch domain {
          case .createPost:
            return .targetNotFound(detail: .create(model: .post))
            
          case .deletePost:
            return .targetNotFound(detail: .delete(model: .post))
            
          case .likePost:
            return .targetNotFound(detail: .update(model: .post))
            
          case .createReview:
            return .targetNotFound(detail: .create(model: .comment))
            
          case .deleteReview:
            return .targetNotFound(detail: .delete(model: .comment))
            
          case .follow:
            return .targetNotFound(detail: .create(model: .follow))
            
          case .unfollow:
            return .targetNotFound(detail: .delete(model: .follow))
          
          case .paymentValidation:
            return .targetNotFound(detail: .pay)
            
          case .createChatRoom:
            return .targetNotFound(detail: .create(model: .chatRoom))
            
          case .fetchChats:
            return .targetNotFound(detail: .fetch(model: .chatRoom))
            
          case .sendChat:
            return .targetNotFound(detail: .fetch(model: .chatRoom))
            
          default:
            return httpStatusError.toDomain
        }
        
        /// 도메인에 대해 분기처리가 필요 없는 에러는 미리 정의한 매핑 에러로 변환
      default:
        return httpStatusError.toDomain
    }
  }
}
