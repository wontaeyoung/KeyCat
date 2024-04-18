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
      let request = base.responseDecodable(of: T.self) { response in
        switch response.result {
          case .success(let value):
            log(base, responseData: response.data, error: response.error)
            single(.success(value))
          case .failure(let error):
            single(.failure(error))
        }
      }
      
      return Disposables.create {
        request.cancel()
      }
    }
  }
  
  func call() -> Single<Bool> {
    
    return Single.create { single in
      let request = base.response { response in
        switch response.result {
          case .success:
            guard let statusCode = response.response?.statusCode else {
              let error = HTTPError.invalidResponse
              log(base, responseData: response.data, error: error)
              single(.failure(error))
              return
            }
            
            log(base, responseData: response.data, error: nil)
            single(.success(true))
            
          case .failure(let error):
            self.log(self.base, responseData: nil, error: error.asAFError)
            single(.failure(error))
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
}
