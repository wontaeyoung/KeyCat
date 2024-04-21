//
//  HTTPStatus+.swift
//  KeyCat
//
//  Created by 원태영 on 4/21/24.
//

extension HTTPError.HTTPStatus {
  var toHTTPStatusError: HTTPStatusError {
    return HTTPStatusError(self)
  }
}
