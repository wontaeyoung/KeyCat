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
  
  func showingCellThrottle(seconds: Int = 1)
  -> Observable<Element> {
    return self.throttle(.seconds(seconds), scheduler: MainScheduler.instance)
  }
  
  func buttonThrottle(seconds: Int = 2)
  -> Observable<Element> {
    return self.throttle(.seconds(seconds), scheduler: MainScheduler.instance)
  }
}
