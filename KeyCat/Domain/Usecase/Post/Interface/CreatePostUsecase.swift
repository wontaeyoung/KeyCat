//
//  CreatePostUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 5/1/24.
//

import Foundation
import RxSwift

protocol CreatePostUsecase {
  
  func execute(files: [Data], post: CommercialPost) -> Single<Bool>
}
