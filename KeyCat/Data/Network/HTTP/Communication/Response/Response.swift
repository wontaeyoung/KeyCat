//
//  Response.swift
//  KeyCat
//
//  Created by 원태영 on 4/11/24.
//

/* Response 정리 아카이브
// MARK: - Athentication
struct JoinResponse: HTTPResponse {
  let user_id: String
  let email: String
  let nick: String
}

struct LoginResponse: HTTPResponse {
  let user_id: String
  let email: String
  let nick: String
  let profileImage: String?
  let accessToken: String
  let refreshToken: String
}

struct RefreshTokenResponse: HTTPResponse {
  let accessToken: String
}

struct WithdrawResponse: HTTPResponse {
  let user_id: String
  let email: String
  let nick: String
}

struct MessageResponse: HTTPResponse {
  let message: String
}

// MARK: - Post
struct UploadImageResponse: HTTPResponse {
  let files: [String]
}

struct CreatePostResponse: HTTPResponse {
  let post_id: String
  let product_id: String?
  let title: String?
  let content: String?
  let content1: String?
  let content2: String?
  let content3: String?
  let content4: String?
  let content5: String?
  let createdAt: String
  let creator: UserResponse
  let files: [String]
  let likes: [String]
  let likes2: [String]
  let hashTags: [String]
  let comments: [CommentResponse]
}

struct FetchPostResponse: HTTPResponse {
  let post_id: String
  let product_id: String?
  let title: String?
  let content: String?
  let content1: String?
  let content2: String?
  let content3: String?
  let content4: String?
  let content5: String?
  let createdAt: String
  let creator: UserResponse
  let files: [String]
  let likes: [String]
  let likes2: [String]
  let hashTags: [String]
  let comments: [CommentResponse]
}

struct FetchPostsResponse: HTTPResponse {
  let data: [FetchPostResponse]
  let next_cursor: String
}

struct FetchSpecificPostResponse: HTTPResponse {
  let post_id: String
  let product_id: String?
  let title: String?
  let content: String?
  let content1: String?
  let content2: String?
  let content3: String?
  let content4: String?
  let content5: String?
  let createdAt: String
  let creator: UserResponse
  let files: [String]
  let likes: [String]
  let likes2: [String]
  let hashTags: [String]
  let comments: [CommentResponse]
}

struct UpdatePostResponse: HTTPResponse {
  let post_id: String
  let product_id: String?
  let title: String?
  let content: String?
  let content1: String?
  let content2: String?
  let content3: String?
  let content4: String?
  let content5: String?
  let createdAt: String
  let creator: UserResponse
  let files: [String]
  let likes: [String]
  let likes2: [String]
  let hashTags: [String]
  let comments: [CommentResponse]
}

struct FetchPostsFromUserQuery: HTTPQuery {
  let next: String
  let limit: String
  let product_id: String
}

struct FetchPostFromUserResponse: HTTPResponse {
  let post_id: String
  let product_id: String?
  let title: String?
  let content: String?
  let content1: String?
  let content2: String?
  let content3: String?
  let content4: String?
  let content5: String?
  let createdAt: String
  let creator: UserResponse
  let files: [String]
  let likes: [String]
  let likes2: [String]
  let hashTags: [String]
  let comments: [CommentResponse]
}

// MARK: - Comment
struct CommentResponse: HTTPResponse {
  let comment_id: String
  let content: String
  let createdAt: String
  let creator: UserResponse
}



struct CreateCommentResponse: HTTPResponse {
  let comment_id: String
  let content: String
  let createdAt: String
  let creator: UserResponse
}



struct UpdateCommentResponse: HTTPResponse {
  let comment_id: String
  let content: String
  let createdAt: String
  let creator: UserResponse
}


// MARK: - Like


struct LikePostResponse: HTTPResponse {
  let like_status: Bool
}



struct FetchLikePostsResponse: HTTPResponse {
  let data: [FetchPostResponse]
  let next_cursor: String
}

// MARK: - Follow
struct FollowResponse: HTTPResponse {
  let nick: String
  let opponent_nick: String
  let following_status: Bool
}

struct CancelFollowResponse: HTTPResponse {
  let nick: String
  let opponent_nick: String
  let following_status: Bool
}

// MARK: - Profile
struct UserResponse: HTTPResponse {
  let user_id: String
  let nick: String
  let profileImage: String?
}

struct FetchMyProfileResponse: HTTPResponse {
  let user_id: String
  let email: String
  let nick: String
  let phoneNum: String?
  let birthDay: String?
  let profileImage: String?
  let followers: [UserResponse]
  let folllowing: [UserResponse]
  let posts: [String]
}



struct UpdateMyProfileResponse: HTTPResponse {
  let user_id: String
  let email: String
  let nick: String
  let phoneNum: String?
  let birthDay: String?
  let profileImage: String?
  let followers: [UserResponse]
  let folllowing: [UserResponse]
  let posts: [String]
}

struct FetchOtherProfileResponse: HTTPResponse {
  let user_id: String
  let nick: String
  let profileImage: String?
  let followers: [UserResponse]
  let following: [UserResponse]
  let posts: [String]
}

struct SearchHashtagResponse: HTTPResponse {
  let data: [FetchPostResponse]
  let next_cursor: String
}
*/
