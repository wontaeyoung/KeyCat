//
//  Reactive+DataRequest.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

import Foundation
import Alamofire
import RxSwift

extension Reactive where Base: DataRequest {
  func call<T: Decodable>(of type: T.Type) -> Single<T> {
    
    return Single.create { single in
      let request = base
        .validate()
        .responseDecodable(of: T.self) { response in
          
          log(base, responseData: response.data, error: response.error)
          
          switch response.result {
            case .success(let value):
              single(.success(value))
              
            case .failure(let error):
              let httpError = mapError(error)
              single(.failure(httpError))
          }
        }
      
      return Disposables.create {
        request.cancel()
      }
    }
  }
  
  func call() -> Single<Void> {
    
    return Single.create { single in
      let request = base
        .validate()
        .response { response in
          
          log(base, responseData: response.data, error: response.error)
          
          switch response.result {
            case .success:
              single(.success(()))
              
            case .failure(let error):
              let httpError = mapError(error)
              single(.failure(httpError))
          }
        }
      
      return Disposables.create {
        request.cancel()
      }
    }
  }
  
  private func log(_ request: DataRequest, responseData: Data?, error: Error?) {
    guard let data = responseData else {
      if let error {
        LogManager.shared.log(with: error.localizedDescription, to: .network, level: .error)
      }
      
      LogManager.shared.log(with: "응답 데이터 파싱 실패", to: .network, level: .error)
      return
    }
    
    let message = """
{응답 파싱 완료}

[응답 데이터]
\(data.toPrettyJsonString)

---
"""
    LogManager.shared.log(with: message, to: .network, level: .info)
  }
  
  private func mapError(_ error: AFError) -> HTTPError {
    
    guard let status = error.responseCode else {
      return .requestFailed
    }
    
    return .unexceptedResponse(status: status)
  }
}
