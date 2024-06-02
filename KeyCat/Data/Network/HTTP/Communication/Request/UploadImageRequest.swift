//
//  UploadImageRequest.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

import Foundation

struct UploadImageRequest: HTTPRequestBody {
  let files: [Data]
}
