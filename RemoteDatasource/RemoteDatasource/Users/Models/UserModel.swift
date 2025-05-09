//
//  UserModel.swift
//  RemoteDatasource
//
//  Created by Filip Kisić on 28.03.2025..
//

public struct UserPageableSecureRequest: Codable {
  public let token: String
  public let page: Int
  public let size: Int
  
  public init(token: String, page: Int, size: Int) {
    self.token = token
    self.page = page
    self.size = size
  }
}

public struct UserResponse: Identifiable, Decodable {
  public let id: String
  public let username: String
  public let profileImageUrl: String?
}
