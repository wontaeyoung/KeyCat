//
//  NetworkMonitor.swift
//  KeyCat
//
//  Created by 원태영 on 4/30/24.
//

import Network

final class NetworkMonitor {
  
  static let shared = NetworkMonitor()
  private init() { }
  
  private let monitor = NWPathMonitor()
  private let monitoringQueue = DispatchQueue(label: "NetworkMonitor", qos: .utility)
  
  func start(handler: @escaping (NWPath) -> Void) {
    
    monitor.pathUpdateHandler = { path in
      GCD.main {
        handler(path)
      }
    }
    
    monitor.start(queue: monitoringQueue)
  }
  
  func stop() {
    monitor.cancel()
  }
}
