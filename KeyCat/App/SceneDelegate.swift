//
//  SceneDelegate.swift
//  KeyCat
//
//  Created by 원태영 on 4/9/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var errorWindow: UIWindow?
  var appCoordinator: AppCoordinator?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: scene)
    
    appCoordinator = AppCoordinator(window: window)
    appCoordinator?.start()
    startMonitoring(scene: scene)
  }
  
  private func startMonitoring(scene: UIScene) {
    NetworkMonitor.shared.start { [weak self] path in
      guard let self else { return }
      
      switch path.status {
        case .satisfied:
          setErrorWindowOff(scene: scene)
        default:
          setErrorWindowOn(scene: scene)
      }
    }
  }
  
  private func setErrorWindowOn(scene: UIScene) {
    guard let windowScene = scene as? UIWindowScene else { return }
    
    self.errorWindow = UIWindow(windowScene: windowScene).configured {
      $0.windowLevel = .statusBar
      $0.addSubview(NetworkUnsatisfiedView(frame: $0.bounds))
      $0.makeKeyAndVisible()
    }
  }
  
  private func setErrorWindowOff(scene: UIScene) {
    errorWindow?.resignKey()
    errorWindow = nil
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    NetworkMonitor.shared.stop()
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    
  }

  func sceneWillResignActive(_ scene: UIScene) {
    
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    
  }
}
