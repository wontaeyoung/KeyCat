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
    var ergonomicPosts: [CommercialPost] = []
    var scissorSwitchPosts: [CommercialPost] = []
  }
  
  enum Action {
    
    case viewOnAppear
    case showErrorAlert(_ error: any Error, _ handler: (() -> Void)?)
  }
  
  var cancellables = Set<AnyCancellable>()
  @Published private(set) var state = State()
  @Published var alert: AlertState = .empty
  
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
        fetchErgonomicPosts()
        fetchscissorSwitchPosts()
        
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
      self.handleError(completion)
    } receiveValue: { owner, output in
      owner.state.capacitivePosts = output
    }
    .store(in: &cancellables)
  }
  
  private func fetchErgonomicPosts() {
    
    fetchCommercialPostUsecase.fetchFilteredPosts {
      let ergonomics: [KeyboardAppearanceInfo.KeyboardDesign] = [.alice, .split]
      return ergonomics.contains($0.keyboard.keyboardAppearanceInfo.design)
    }
    .asPublisher()
    .with(self)
    .sink { completion in
      self.handleError(completion)
    } receiveValue: { owner, output in
      owner.state.ergonomicPosts = output
    }
    .store(in: &cancellables)
  }
  
  private func fetchscissorSwitchPosts() {
    
    fetchCommercialPostUsecase.fetchFilteredPosts {
      $0.keyboard.keyboardInfo.inputMechanism == .scissorSwitch
    }
    .map { Array($0.prefix(4)) }
    .asPublisher()
    .with(self)
    .sink { completion in
      self.handleError(completion)
    } receiveValue: { owner, output in
      owner.state.scissorSwitchPosts = output
    }
    .store(in: &cancellables)
  }
  
  private func handleError(_ completion: Subscribers.Completion<any Error>) {
    if case .failure(let error) = completion {
      act(.showErrorAlert(error, nil))
    }
  }
}
