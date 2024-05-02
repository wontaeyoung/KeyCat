//
//  NetworkMonitor.swift
//  KeyCat
//
//  Created by 원태영 on 4/30/24.
//

import Network
import RxRelay

final class NetworkMonitor {
  
  static let shared = NetworkMonitor()
  private init() { 
    
    monitor.pathUpdateHandler = { path in
      self.networkStateSatisfied.accept(path.status == .satisfied)
    }
    
    monitor.start(queue: monitoringQueue)
  }
  
  private let monitor = NWPathMonitor()
  private let monitoringQueue = DispatchQueue(label: "NetworkMonitor", qos: .utility)
  
  let networkStateSatisfied = PublishRelay<Bool>()
}
