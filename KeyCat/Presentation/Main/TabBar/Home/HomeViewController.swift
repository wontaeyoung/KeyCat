//
//  HomeViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/10/24.
//

import SwiftUI
import SnapKit
import RxSwift
import RxCocoa

final class HomeViewController: RxBaseViewController {
  
  // MARK: - UI
  private let homeViewHostingController = UIHostingController(rootView: HomeView())
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubview(homeViewHostingController.view)
  }
  
  override func setConstraint() {
    homeViewHostingController.view.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
