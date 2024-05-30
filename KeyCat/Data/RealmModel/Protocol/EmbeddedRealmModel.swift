//
//  EmbeddedRealmModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/30/24.
//

import Foundation
import RealmSwift

public protocol EmbeddedRealmModel: EmbeddedObject {
  
  associatedtype Column: RawRepresentable where Column.RawValue == String
}
