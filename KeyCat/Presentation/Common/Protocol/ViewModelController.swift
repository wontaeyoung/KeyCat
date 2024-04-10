//
//  ViewModelController.swift
//  KazStore
//
//  Created by 원태영 on 4/5/24.
//

protocol ViewModelController: AnyObject {
  associatedtype ViewModelType = ViewModel
  
  var viewModel: ViewModelType { get }
}

