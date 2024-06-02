//
//  ChatRouter.swift
//  KeyCat
//
//  Created by 원태영 on 5/19/24.
//

import Foundation
import Alamofire

enum ChatRouter: Router {
  
  case roomCreate(request: CreateChatRoomRequest)
  case myChatRoomsFetch
  case chatsFetch(roomID: Entity.RoomID, query: FetchChatsQuery)
  case chatSend(roomID: Entity.RoomID, request: SendChatRequest)
  case chatImageUpload(roomID: Entity.RoomID)
  
  var method: HTTPMethod {
    switch self {
      case .roomCreate, .chatSend, .chatImageUpload:
        return .post
      
      case .myChatRoomsFetch, .chatsFetch:
        return .get
    }
  }
  
  var path: String {
    switch self {
      case .roomCreate, .myChatRoomsFetch:
        return "/chats"
        
      case let .chatsFetch(roomID, _):
        return "/chats/\(roomID)"
        
      case let .chatSend(roomID, _):
        return "/chats/\(roomID)"
        
      case .chatImageUpload(let roomID):
        return "/chats/\(roomID)/files"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .roomCreate, .chatSend:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: UserInfoService.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.applicationJson)
        ]
        
      case .myChatRoomsFetch, .chatsFetch:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: UserInfoService.accessToken)
        ]
        
      case .chatImageUpload:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: UserInfoService.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.multipartFormData)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .roomCreate, .myChatRoomsFetch, .chatSend, .chatImageUpload:
        return nil
        
      case let .chatsFetch(_, query):
        return makeFetchChatsParameters(query: query)
    }
  }
  
  var body: Data? {
    switch self {
      case .roomCreate(let request):
        return requestToBody(request)
        
      case .myChatRoomsFetch, .chatsFetch, .chatImageUpload:
        return nil
        
      case let .chatSend(_, request):
        return requestToBody(request)
    }
  }
}

extension ChatRouter: URLConvertible {
  func asURL() throws -> URL {
    guard let url = try asURLRequest().url else {
      throw HTTPError.requestFailed
    }
    
    return url
  }
}

extension ChatRouter {
  private func makeFetchChatsParameters(query: FetchChatsQuery) -> Parameters {
    return [KCParameter.Key.cursorDate: query.cursor_date]
  }
}
