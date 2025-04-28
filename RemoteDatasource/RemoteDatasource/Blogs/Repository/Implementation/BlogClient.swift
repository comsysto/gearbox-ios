//
//  BlogClient.swift
//  RemoteDatasource
//
//  Created by Filip Kisić on 05.12.2024..
//
import Foundation

@available(iOS 15.0, *)
class BlogClient : BlogDatasourceType {
  private let baseUrl = "http://localhost:8080/api/blog"
  
  func getTrending(_ blogRequest: BlogPageableSecureRequest) async throws -> PageableResponse<[BlogResponse]> {
    return try await sendPageableSecureRequest("trending", blogRequest)
  }
  
  func getLatest(_ blogRequest: BlogPageableSecureRequest) async throws -> PageableResponse<[BlogResponse]> {
    return try await  sendPageableSecureRequest("latest", blogRequest)
  }
  
  func search(_ blogRequest: BlogPageableSecureRequest, query: String) async throws -> PageableResponse<[BlogResponse]> {
    let body = serializeStringToJSONData(query)
    return try await sendPageableSecureRequest("search", blogRequest, method: "POST", body: body)
  }
  
  func getByAuthor(_ blogRequest: BlogPageableSecureRequest, userId: String) async throws -> PageableResponse<[BlogResponse]> {
    return try await sendPageableSecureRequest("byAuthor/\(userId)", blogRequest)
  }

  func getLikedBy(_ blogRequest: BlogPageableSecureRequest, userId: String) async throws -> PageableResponse<[BlogResponse]> {
    return try await sendPageableSecureRequest("likedBy/\(userId)", blogRequest)
  }
  
  private func sendPageableSecureRequest(
    _ endpoint: String,
    _ blogRequest: BlogPageableSecureRequest,
    method: String = "GET",
    body: Data? = nil
  ) async throws -> PageableResponse<[BlogResponse]> {
    let url = URL(string: baseUrl + "/\(endpoint)/\(blogRequest.page)/\(blogRequest.size)")!
    
    let request = URLRequestBuilder(url: url)
      .setAuthorization(token: blogRequest.token, method: method)
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
  
  private func mapResponseToApplicationObject(response: HTTPURLResponse?, data: Data) async throws -> PageableResponse<[BlogResponse]> {
    switch response?.statusCode {
      case 200:
        let decoder = buildConfiguredDecoder()
        return try decoder.decode(PageableResponse<[BlogResponse]>.self, from: data)
      default:
        throw BlogException.serverError("error.server-error")
    }
  }
  
  private func buildConfiguredDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    
    return decoder
  }
}
