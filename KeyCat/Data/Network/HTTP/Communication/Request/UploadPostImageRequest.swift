//
//  UploadPostImageRequest.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

import Foundation

struct UploadPostImageRequest: HTTPRequestBody {
  let files: [Data]
}
