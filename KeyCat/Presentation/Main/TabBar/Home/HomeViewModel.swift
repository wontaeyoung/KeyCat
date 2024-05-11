//
//  HomeViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/10/24.
//

import Foundation
import Combine

final class HomeViewModel: ObservableViewModel {
  
  struct State {
    
    var capacitivePosts: [CommercialPost] = []
  }
  
  enum Action {
    
    case viewOnAppear
    case showErrorAlert(_ error: any Error, _ handler: (() -> Void)?)
  }
  
  var cancellables = Set<AnyCancellable>()
  @Published private(set) var state = State()
  @Published var alert: Alert = .empty
  
  private let fetchCommercialPostUsecase: FetchCommercialPostUsecase
  
  init(
    fetchCommercialPostUsecase: FetchCommercialPostUsecase = FetchCommercialPostUsecaseImpl()
  ) {
    self.fetchCommercialPostUsecase = fetchCommercialPostUsecase
  }
  
  func act(_ action: Action) {
    
    switch action {
      case .viewOnAppear:
        fetchCapacitivePosts()
        
      case let .showErrorAlert(error, handler):
        showErrorAlert(error: error, handler: handler)
    }
  }
}

extension HomeViewModel {
  
  private func fetchCapacitivePosts() {
    
    fetchCommercialPostUsecase.fetchFilteredPosts {
      $0.keyboard.keyboardInfo.inputMechanism == .capacitiveNonContact
    }
    .asPublisher()
    .with(self)
    .sink { completion in
      if case .failure(let error) = completion {
        self.act(.showErrorAlert(error, nil))
      }
    } receiveValue: { owner, output in
      owner.state.capacitivePosts = output
    }
    .store(in: &cancellables)
  }
}
