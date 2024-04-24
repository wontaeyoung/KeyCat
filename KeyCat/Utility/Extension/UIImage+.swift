//
//  UIImage+.swift
//  KeyCat
//
//  Created by 원태영 on 4/24/24.
//

import UIKit

extension UIImage {
  
  func resized(newWidth: CGFloat) -> UIImage {
    let scale: CGFloat = newWidth / self.size.width
    let newHeight: CGFloat = scale * self.size.height
    
    let size = CGSize(width: newWidth, height: newHeight)
    let render = UIGraphicsImageRenderer(size: size)
    let renderImage = render.image { context in
      self.draw(in: CGRect(origin: .zero, size: size))
    }
    
    return renderImage
  }
  
  var compressedJPEGData: Data? {
    let maxQuality: CGFloat = 1.0
    let minQuality: CGFloat = 0.0
    let maxSizeInBytes = BusinessValue.maxImageFileVolumeMB * 1024 * 1024
    
    // 최대 품질(무압축)에서 시작
    var compressionQuality: CGFloat = maxQuality
    
    // 이미지를 JPEG 데이터로 변환
    guard var compressedData = self.jpegData(compressionQuality: compressionQuality) else { return nil }
    
#if DEBUG
    LogManager.shared.log(with: "압축 전 - \(Self.dataVolumnMB(data: compressedData))", to: .local, level: .debug)
#endif
    /// 용량이 최대 기준치 이하가 되었거나, 압축률이 100%가 아니면 반복 수행
    while Double(compressedData.count) > maxSizeInBytes && compressionQuality > minQuality {
      // 압축률 10% 증가 후 다시 시도
      compressionQuality -= 0.1
      
      guard let newData = self.jpegData(compressionQuality: compressionQuality) else { break }
      compressedData = newData
    }
    
#if DEBUG
    LogManager.shared.log(with: "압축 후 - \(Self.dataVolumnMB(data: compressedData))", to: .local, level: .debug)
#endif
    
    return compressedData
  }
  
  static func dataVolumnMB(data: Data) -> String {
    let value = Double(data.count) / (1024 * 1024)
    
    return NumberFormatManager.shared.toRoundedWith(from: value, fractionDigits: 2, unit: .MB)
  }
}
