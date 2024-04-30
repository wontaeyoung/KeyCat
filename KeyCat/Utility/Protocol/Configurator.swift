//
//  Configurator+.swift
//  KazStore
//
//  Created by 원태영 on 4/5/24.
//

import UIKit
import PhotosUI
import Toast

protocol Configurator { }

extension Configurator where Self: Any {
  
  mutating func apply(_ apply: (inout Self) -> Void) {
    apply(&self)
  }
  
  func applied(_ apply: (inout Self) -> Void) -> Self {
    var configurableSelf = self
    apply(&configurableSelf)
    
    return configurableSelf
  }
}

extension Configurator where Self: AnyObject {
  
  func configure(_ apply: (Self) -> Void) {
    apply(self)
  }
  
  func configured(_ apply: (Self) -> Void) -> Self {
    apply(self)
    return self
  }
}

extension NSObject: Configurator { }
extension Array: Configurator { }
extension Dictionary: Configurator { }
extension Set: Configurator { }

extension PHPickerConfiguration: Configurator { }
extension UIButton.Configuration: Configurator { }
extension URLRequest: Configurator { }

extension Calendar: Configurator { }

extension UIListContentConfiguration: Configurator { }
extension UICollectionLayoutListConfiguration: Configurator { }
extension UIBackgroundConfiguration: Configurator { }
extension UIConfigurationTextAttributesTransformer: Configurator { }
extension AttributeScopes: Configurator { }
extension AttributeContainer: Configurator { }

extension NSDiffableDataSourceSnapshot: Configurator { }

extension UIListContentConfiguration.TextProperties: Configurator { }
extension UIListContentConfiguration.ImageProperties: Configurator { }

extension ToastStyle: Configurator { }
