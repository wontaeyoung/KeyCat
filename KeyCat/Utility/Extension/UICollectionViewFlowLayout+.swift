//
//  UICollectionViewFlowLayout+.swift
//  KeyCat
//
//  Created by 원태영 on 5/1/24.
//

import UIKit

extension UICollectionViewFlowLayout {
  static func gridLayout(cellCount: CGFloat, cellSpacing: CGFloat) -> UICollectionViewFlowLayout {
    let cellWidth: CGFloat = (UIScreen.main.bounds.width - (cellSpacing * (2 + cellCount - 1))) / cellCount
    
    return UICollectionViewFlowLayout().configured {
      $0.itemSize = CGSize(width: cellWidth, height: cellWidth * 2.5)
      $0.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
      $0.minimumInteritemSpacing = cellSpacing
      $0.scrollDirection = .vertical
    }
  }
}
