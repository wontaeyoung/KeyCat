//
//  Coordinator.swift
//  KazStore
//
//  Created by 원태영 on 4/5/24.
//

import UIKit

protocol CoordinatorDelegate: AnyObject {
  
  func coordinatorDidEnd(_ childCoordinator: Coordinator)
}

protocol Coordinator: AnyObject {
  
  // MARK: - Property
  var navigationController: UINavigationController { get set }
  var delegate: CoordinatorDelegate? { get set }
  var childCoordinators: [Coordinator] { get set }
  
  // MARK: - Initialzier
  init(_ navigationController: UINavigationController)
  
  // MARK: - Method
  func start()
  func end()
  func push(_ viewController: UIViewController, animation: Bool)
  func pop(animation: Bool)
  func popToRoot(animation: Bool)
  func dismiss(animation: Bool)
  func emptyOut()
  func showErrorAlert(error: Error, completion: (() -> Void)?)
  func showAlert(
    title: String,
    message: String,
    okTitle: String?,
    okStyle: UIAlertAction.Style,
    isCancelable: Bool,
    completion: (() -> Void)?
  )
}

// MARK: - View Navigation
internal extension Coordinator {
  
  func end() {
    self.emptyOut()
    self.delegate?.coordinatorDidEnd(self)
  }
  
  func push(_ viewController: UIViewController, animation: Bool = true) {
    GCD.main {
      self.navigationController.pushViewController(viewController, animated: animation)
    }
  }
  
  func pop(animation: Bool = true) {
    GCD.main {
      self.navigationController.popViewController(animated: animation)
    }
  }
  
  func popToRoot(animation: Bool = true) {
    GCD.main {
      self.navigationController.popToRootViewController(animated: animation)
    }
  }
  
  func present(_ viewController: UIViewController, style: UIModalPresentationStyle = .automatic, animation: Bool = true) {
    viewController.modalPresentationStyle = style
    GCD.main {
      self.navigationController.present(viewController, animated: animation)
    }
  }
  
  func dismiss(animation: Bool = true) {
    GCD.main {
      self.navigationController.dismiss(animated: animation)
    }
  }
  
  func emptyOut() {
    self.childCoordinators.removeAll()
  }
  
  func showErrorAlert(error: Error, completion: (() -> Void)? = nil) {
    guard let error = error as? AppError else {
      let unknownError = CommonError.unknownError(error: error)
      LogManager.shared.log(with: unknownError, to: .local)
      showErrorAlert(error: unknownError)
      
      return
    }
    
    let alertController = UIAlertController(
      title: error.alertDescription,
      message: nil,
      preferredStyle: .alert
    )
      .setAction(title: "확인", style: .default, completion: completion)
    
    GCD.main {
      self.present(alertController)
    }
  }
  
  func showAlert(
    title: String,
    message: String,
    okTitle: String? = nil,
    okStyle: UIAlertAction.Style = .default,
    isCancelable: Bool = false,
    completion: (() -> Void)? = nil
  ) {
    var alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      .setAction(title: okTitle ?? "확인", style: okStyle, completion: completion)
      
    if isCancelable {
      alertController = alertController.setCancelAction()
    }
    
    GCD.main {
      self.present(alertController)
    }
  }
  
  func addChild(_ childCoordinator: Coordinator) {
    self.childCoordinators.append(childCoordinator)
  }
}
