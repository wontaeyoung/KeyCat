//
//  NSCollectionLayoutSection+.swift
//  KeyCat
//
//  Created by 원태영 on 4/29/24.
//

import UIKit

extension NSCollectionLayoutSection {
  
  static func makeCardSection(
    cardSpacing: CGFloat,
    heightRatio: CGFloat,
    sectionInset: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0),
    header: Bool = false,
    headerHeight: CGFloat = 30
  ) -> NSCollectionLayoutSection {
    
    let cardItem: NSCollectionLayoutItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
      )
    )
    
    let cardGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
      ),
      subitems: [cardItem]
    )
    
    let section = NSCollectionLayoutSection(group: cardGroup)
    section.orthogonalScrollingBehavior = .groupPagingCentered
    section.contentInsets = sectionInset
    section.interGroupSpacing = cardSpacing
    
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
  
  static func makeHorizontalScrollSection(
    itemSpacing: Double = 0,
    sectionInset: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0),
    header: Bool = false,
    headerHeight: CGFloat = 30
  ) -> NSCollectionLayoutSection {
    
    let item: NSCollectionLayoutItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
      )
    )
    
    let group: NSCollectionLayoutGroup = .horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .absolute(100),
        heightDimension: .absolute(100)
      ),
      subitems: [item]
    )
    
    group.interItemSpacing = .fixed(itemSpacing)
    
    let section = NSCollectionLayoutSection(group: group).configured {
      $0.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
      $0.contentInsets = sectionInset
      $0.interGroupSpacing = itemSpacing
    }
    
    if header {
      section.boundarySupplementaryItems = [
        NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(headerHeight)
          ),
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top
        )
      ]
    }
    
    return section
  }
}
