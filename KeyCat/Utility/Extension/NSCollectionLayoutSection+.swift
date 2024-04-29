//
//  NSCollectionLayoutSection+.swift
//  KeyCat
//
//  Created by 원태영 on 4/29/24.
//

import UIKit

extension NSCollectionLayoutSection {
  
  static func makeHorizontalScrollSection(
    itemSpacing: Double = 0,
    sectionInset: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0),
    header: Bool = false,
    headerHeight: CGFloat = 30
  ) -> NSCollectionLayoutSection {
    
    let item: NSCollectionLayoutItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.3),
        heightDimension: .fractionalHeight(1)
      )
    )
    
    let group: NSCollectionLayoutGroup = .horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalWidth(0.3)
      ),
      subitems: [item]
    )
    
    group.interItemSpacing = .fixed(itemSpacing)
    
    let section = NSCollectionLayoutSection(group: group).configured {
      $0.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
      $0.contentInsets = sectionInset
    }
    
    if header {
      section.boundarySupplementaryItems = [
        NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(headerHeight)),
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top
        )
      ]
    }
    
    return section
  }
}
