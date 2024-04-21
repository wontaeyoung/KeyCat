//
//  ObservableType+.swift
//  KeyCat
//
//  Created by 원태영 on 4/10/24.
//

import RxSwift

enum StreamThread {
  case main
  case global
}

extension ObservableType {
  
  func thread(_ thread: StreamThread) -> Observable<Element> {
    switch thread {
      case .main:
        return self.observe(on: MainScheduler.instance)
        
      case .global:
        return self.observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
  }
  
  func buttonThrottle()
  -> Observable<Element> {
    return self.throttle(.seconds(2), scheduler: MainScheduler.instance)
  }
}
