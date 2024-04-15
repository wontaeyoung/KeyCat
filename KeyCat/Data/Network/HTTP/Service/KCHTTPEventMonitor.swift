//
//  KCHTTPEventMonitor.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

import Alamofire
import Foundation

final class KCHTTPEventMonitor: EventMonitor {
  
  static let shared = KCHTTPEventMonitor()
  private init() { }
  
  // 요청이 시작될 때
  func requestDidResume(_ request: Request) {
    guard let request = request.request?.urlRequest else { return }
    var body: String = "body 없음"
    if let httpBody = request.httpBody,
        let bodyString = String(data: httpBody, encoding: .utf8) { body = bodyString }
    
    let message =  """
요청시작

요청 URL
\(request.url?.absoluteString ?? "URL 확인 불가")

요청 메서드
\(request.method?.rawValue ?? "HTTP 메서드 확인 불가")

요청 헤더
\(request.headers.dictionary.description)

요청 바디
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
  func request(_ request: Request, didCompleteTask task: URLSessionTask, with error: Error?) {
    guard let httpResponse = task.response as? HTTPURLResponse else {
      return
    }
    
    let message = """
응답 완료

상태코드
\(httpResponse.statusCode)

헤더정보
\(httpResponse.headers.description)

에러 메세지
\(error?.localizedDescription ?? "에러 없음")

---
"""
    LogManager.shared.log(with: message, to: .network, level: .info)
  }

  // 데이터 수신 시점마다 호출
  // 다운로드 작업처럼 여러 시점에 걸쳐 받는 데이터 처리
  func request(_ request: Request, didReceiveData data: Data) { }

  // 데이터 요청에 대한 응답 결과 처리
  func requestValue(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
    guard let data = response.data,
          let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
          let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
          let prettyJsonString = String(data: jsonData, encoding: .utf8)
    else {
      
      LogManager.shared.log(with: "응답 데이터 파싱 실패", to: .network, level: .error)
      
      if let error = response.error {
        let message = """
응답 에러 발생
\(error.localizedDescription)

---
"""
        LogManager.shared.log(with: message, to: .network, level: .error)
      }
      
      return
    }
    
    let message = """
응답 파싱 완료

응답 데이터
\(prettyJsonString)

---
"""
    LogManager.shared.log(with: message, to: .network, level: .info)
  }
}
