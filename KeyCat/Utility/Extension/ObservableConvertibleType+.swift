//
//  ObservableConvertibleType+.swift
//  KeyCat
//
//  Created by 원태영 on 5/10/24.
//

import RxSwift
import Combine
import RxRelay

extension ObservableConvertibleType {
  func asPublisher() -> AnyPublisher<Element, Error> {
    let subject = PassthroughSubject<Element, Error>()
    
    let disposable = self.asObservable()
      .subscribe(
        onNext: { subject.send($0) },
        onError: { subject.send(completion: .failure($0)) },
        onCompleted: { subject.send(completion: .finished) }
      )
    
    return subject
      .handleEvents(receiveCancel: {
        disposable.dispose()
      })
      .eraseToAnyPublisher()
  }
}

