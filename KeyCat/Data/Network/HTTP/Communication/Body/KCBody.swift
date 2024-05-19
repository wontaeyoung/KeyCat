//
//  KCBody.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

enum KCBody {
  enum Key {
    static let imageFiles: String = "files"
    static let profileImageFile: String = "profile"
  }
  
  enum Value {
    static let fileName: String = "Keycat.\(Constant.FileExtension.jpg)"
    static let mimeTypePNG: String = "image/\(Constant.FileExtension.png)"
    static let mimeTypeJPEG: String = "image/\(Constant.FileExtension.jpeg)"
  }
}
