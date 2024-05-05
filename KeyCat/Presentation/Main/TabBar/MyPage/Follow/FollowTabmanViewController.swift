//
//  FollowTabmanViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Tabman
import Pageboy

final class FollowTabmanViewController: TabmanRxBaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var viewControllers: [UIViewController] = [
    FollowListViewController(viewModel: viewModel, followTab: .following),
    FollowListViewController(viewModel: viewModel, followTab: .follower)
  ]
  
  private lazy var bar = TMBar.ButtonBar().configured {
    $0.layout.transitionStyle = .snap
    $0.layout.alignment = .centerDistributed
    $0.layout.contentMode = .fit
    
    $0.backgroundView.style = .clear
    $0.backgroundColor = KCAsset.Color.white.color
    
    $0.buttons.customize {
      $0.tintColor = KCAsset.Color.darkGray.color
      $0.selectedTintColor = KCAsset.Color.black.color
      $0.font = KCAsset.Font.bold(size: 14).font
    }
    
    $0.indicator.configure {
      $0.weight = .medium
      $0.overscrollBehavior = .compress
      $0.tintColor = KCAsset.Color.brand.color
    }
  }
  
  // MARK: - Property
  let viewModel: FollowListViewModel
  
  // MARK: - Initializer
  init(
    viewModel: FollowListViewModel,
    followTab: FollowTab
  ) {
    self.viewModel = viewModel
    
    super.init()
    self.dataSource = self
    addBar(bar, dataSource: self, at: .top)
    self.scrollToPage(.at(index: followTab.rawValue), animated: true)
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    
  }
  
  override func setConstraint() {
    
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    
  }
  
  // MARK: - Method
  
}

extension FollowTabmanViewController: PageboyViewControllerDataSource, TMBarDataSource {
  
  enum FollowTab: Int, CaseIterable {
    
    case following
    case follower
    
    var title: String {
      switch self {
        case .following: "팔로잉"
        case .follower: "팔로워"
      }
    }
    
    var barItem: TMBarItemable {
      return TMBarItem(title: title)
    }
    
    init(_ index: Int) {
      self = Self(rawValue: index) ?? Self.following
    }
  }
  
  func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
    
    return FollowTab(index).barItem
  }
  
  func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
    return viewControllers.count
  }
  
  func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
    return viewControllers[index]
  }
  
  func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
    return nil
  }
}
