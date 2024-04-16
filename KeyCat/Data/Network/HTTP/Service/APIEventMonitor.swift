//
//  APIEventMonitor.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

import Alamofire
import Foundation

final class APIEventMonitor: EventMonitor {
  
  static let shared = APIEventMonitor()
  private init() { }
  
  // 요청이 시작될 때
  func requestDidResume(_ request: Request) {
    guard let request = request.request?.urlRequest else { return }
    var body: String = "body 없음"
    if let httpBody = request.httpBody {
      body = httpBody.toPrettyJsonString
    }
    
    let message =  """
{요청시작}

[요청 URL]
\(request.url?.absoluteString ?? "URL 확인 불가")

[요청 메서드]
\(request.method?.rawValue ?? "HTTP 메서드 확인 불가")

[요청 헤더]
\(request.headers.dictionary.description)

[요청 바디]
\(body)

---
"""
    LogManager.shared.log(with: message, to: .network, level: .info)
  }
  
  // URLRequest 생성 -> 네트워크 요청 시작 직전
  func request(_ request: Request, didCreateURLRequest urlRequest: URLRequest) { }
  
  // URLSessionTask 생성 직후
  // 세션 작업 추적 혹은 관련 데이터 로깅
  func request(_ request: Request, didCreateTask task: URLSessionTask) { }
  
  // 요청 작업 성공 혹은 취소 시점
  func requestDidFinish(_ request: Request) { }
  
  // 요청 후 응답 완료
  // 성공 여부에 상관없이 호출
  func request(_ request: Request, didCompleteTask task: URLSessionTask, with error: AFError?) {
    guard let httpResponse = task.response as? HTTPURLResponse else {
      return
    }
    
    let errorMessage = error?.localizedDescription ?? "에러 없음"
    let message = """
{응답 완료}

[상태코드]
\(httpResponse.statusCode)

[헤더정보]
\(httpResponse.headers.description)

---
"""
    LogManager.shared.log(with: message, to: .network, level: .info)
  }
  
  func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
    
    guard let error = response.error, let data = response.data else { return }
    
    let message = """
{파싱 에러}
[에러 메세지]
\(error)

[응답 Json]
\(data.toPrettyJsonString)
"""
    LogManager.shared.log(with: message, to: .network, level: .error)
  }
}
