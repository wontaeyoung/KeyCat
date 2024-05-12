//
//  ObservableViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/10/24.
//

import Foundation
import Combine

protocol ObservableViewModel: ObservableObject {
  
  associatedtype State
  associatedtype Action
  
  var cancellables: Set<AnyCancellable> { get set }
  var alert: AlertState { get set }
  
  func act(_ action: Action)
}

extension ObservableViewModel {
  
  func showErrorAlert(error: any Error, handler: (() -> Void)?) {
    
    guard let error = error as? KCError else {
      self.alert = AlertState(
        title: "오류 발생",
        description: "알 수 없는 오류가 발생했어요. 문제가 지속되면 개발자에게 알려주세요."
      )
      
      return
    }
    
    self.alert = AlertState(
      title: "오류 발생",
      description: error.alertDescription,
      action: handler
    )
  }
}
