//
//  PaymentViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import WebKit
import iamport_ios

final class PaymentViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let paymentWebView = WKWebView()
  
  // MARK: - Property
  let viewModel: PaymentViewModel
  
  // MARK: - Initializer
  init(viewModel: PaymentViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubview(paymentWebView)
  }
  
  override func setConstraint() {
    paymentWebView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    
    let input = PaymentViewModel.Input()
    let output = viewModel.transform(input: input)
    
    output.paymentInfo
      .drive(with: self) { owner, paymentInfo in
        
        Iamport.shared.paymentWebView(
          webViewMode: owner.paymentWebView,
          userCode: paymentInfo.userCode,
          payment: paymentInfo.payment
        ) {
          input.responseReceivedEvent.accept($0)
        }
      }
      .disposed(by: disposeBag)
    
    input.viewDidLoadEvent.accept(())
  }
}
