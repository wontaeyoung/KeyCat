//
//  APIService.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

struct APIService {
  
  private let session = Session(eventMonitors: [APIEventMonitor.shared])
  
  func callRequest<T: Decodable>(with router: Router, of type: T.Type) -> Single<T> {
    return session
      .request(router)
      .rx
      .call(of: T.self)
  }
  
  func callReqeust(with router: Router) -> Single<Bool> {
    return session
      .request(router)
      .rx
      .call()
  }
  
  func callImageUploadRequest(data: [Data]) -> Single<UploadPostImageResponse> {
    let router = PostRouter.postImageUpload
    
    return session
      .upload(multipartFormData: { multipartFormData in
        data.forEach {
          multipartFormData.append(
            $0,
            withName: KCBody.Key.imageFiles,
            fileName: KCBody.Value.fileName,
            mimeType: KCBody.Value.mimeTypePNG
          )
        }
      }, to: router, headers: router.headers)
      .rx
      .call(of: UploadPostImageResponse.self)
  }
}
