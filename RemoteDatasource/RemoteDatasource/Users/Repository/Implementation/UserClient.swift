//
//  UserClient.swift
//  RemoteDatasource
//
//  Created by Filip Kisić on 31.03.2025..
//
import Foundation

@available(iOS 15.0, *)
class UserClient: UserDatasourceType {
  
  private let baseUrl = "http://localhost:8080/api/user"
  
  func search(_ userRequest: UserPageableSecureRequest, query: String) async throws -> PageableResponse<[UserResponse]> {
    let url = URL(string: "\(baseUrl)/search/\(userRequest.page)/\(userRequest.size)")!
    
    let body = serializeStringToJSONData(query)!
    
    let request = URLRequestBuilder(url: url)
      .setAuthorization(token: userRequest.token, method: "POST")
      .setBody(data: body)
      .build()
    
    let (data, status) = try await URLSession.shared.data(for: request)
    let httpResponse = status as? HTTPURLResponse
    
    return try await mapResponseToApplicationObject(response: httpResponse, data: data)
  }
  
  private func serializeStringToJSONData(_ string: String) -> Data? {
    guard let data = string.data(using: .utf8) else { return nil }
    return data
  }
  
  private func mapResponseToApplicationObject(response: HTTPURLResponse?, data: Data) async throws -> PageableResponse<[UserResponse]> {
    switch response?.statusCode {
      case 200:
        return try JSONDecoder().decode(PageableResponse<[UserResponse]>.self, from: data)
      default:
        throw UserException.serverError("error.server-error")
    }
  }
}
