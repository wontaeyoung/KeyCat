//
//  KCError.swift
//  KeyCat
//
//  Created by 원태영 on 4/20/24.
//

enum KCError: AppError {
  
  case missingRequired // 400
  case accessFailed(detail: AccessCase) // 401
  case conflict(detail: ConflictCase) // 409
  case targetNotFound(detail: RequestCase) // 410
  case retrySignIn // 418
  case overcall // 429
  case noAuthority // 445
  case serverError // 500
  
  case networkError // -
  case unknown // -
  
  var logDescription: String {
    switch self {
      default:
        return ""
    }
  }
  
  var alertDescription: String {
    switch self {
      case .missingRequired:
        return "필수 정보가 누락되었어요. 문제가 지속되면 고객센터에 문의해주세요."
        
      case .accessFailed(let detail):
        return detail.alertDescription
        
      case .conflict(let detail):
        return detail.alertDescription
        
      case .targetNotFound(let detail):
        return detail.alertDescription
        
      case .retrySignIn:
        return "로그인 정보가 만료됐어요. 안전을 위해 다시 로그인해주세요."
        
      case .overcall:
        return "요청 횟수가 많아서 실패했어요. 잠시 후에 다시 시도해주세요."
        
      case .noAuthority:
        return "본인이 작성하지 않은 내용은 수정할 수 없어요."
        
      case .serverError:
        return "서버에 잠시 문제가 생겼어요. 잠시 후에 다시 시도해주세요."
        
      case .networkError:
        return "요청에 실패했어요. 와이파이 연결을 확인하거나 데이터 네트워크 상태를 확인하시고, 잠시 후 다시 시도해주세요."
        
      case .unknown:
        return "알 수 없는 문제가 발생했어요. 문제가 지속되면 고객센터에 문의해주세요."
    }
  }
}

extension KCError {
  
  /// 도메인 모델을 식별하기 위한 케이스
  enum DomainModel: String {
    
    case post = "게시물"
    case review = "리뷰"
    case comment = "댓글"
    
    var name: String {
      return self.rawValue
    }
  }
  
  /// 401 응답을 식별하기 위한 요청 케이스
  enum AccessCase {
    
    case login
    case accessToken
    
    var alertDescription: String {
      switch self {
        case .login:
          return "이메일 또는 비밀번호를 잘못 입력했어요. 입력하신 내용을 다시 확인해주세요."
          
        case .accessToken:
          return "인증 정보에 문제가 생겼어요. 다시 로그인해주세요."
      }
    }
  }
  
  /// 409 응답을 식별하기 위한 요청 케이스
  enum ConflictCase {
    
    case emailDuplicated
    
    var alertDescription: String {
      switch self {
        case .emailDuplicated:
          return "이미 가입된 이메일이에요."
      }
    }
  }
  
  /// 410 응답을 식별하기 위한 요청 케이스
  enum RequestCase {
    
    case create(model: DomainModel)
    case update(model: DomainModel)
    case delete(model: DomainModel)
    
    var alertDescription: String {
      switch self {
        case .create(let model):
          return "\(model.name)을 작성하는데 실패했어요. 잠시 후에 다시 시도해주세요."
        case .update(let model):
          return "수정할 \(model.name)을 찾지 못했어요. 잠시 후에 다시 시도해주세요."
        case .delete(let model):
          return "삭제할 \(model.name)을 찾지 못했어요. 잠시 후에 다시 시도해주세요."
      }
    }
  }
}
