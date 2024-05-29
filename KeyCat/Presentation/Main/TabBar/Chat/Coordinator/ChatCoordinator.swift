//
//  ChatCoordinator.swift
//  KeyCat
//
//  Created by 원태영 on 5/26/24.
//

import UIKit

final class ChatCoordinator: SubCoordinator {
  
  weak var delegate: CoordinatorDelegate?
  weak var signOutDelegate: SignOutDelegate?
  weak var tabBarDelegate: TabBarDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    showChatRoomListView()
  }
}

extension ChatCoordinator {
  
  private func showChatRoomListView() {
    
    let vm = ChatRoomListViewModel()
      .coordinator(self)
    
    let vc = ChatRoomListViewController(viewModel: vm)
    
    push(vc)
  }
}

extension ChatCoordinator: SignOutDelegate { }
