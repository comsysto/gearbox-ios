//
//  BlogClient.swift
//  GearboxDatasource
//
//  Created by Filip Kisić on 05.12.2024..
//
import Foundation

@available(iOS 15.0, *)
class BlogClient : BlogDatasource {
  
  private let baseUrl = "http://localhost:8080/api/blog"
  
  func getTrending(_ blogRequest: BlogPageableSecureRequest) async throws -> PageableResponse<[BlogResponse]> {
    return try await sendPageableSecureRequest("trending", blogRequest)
  }
  
  func getLatest(_ blogRequest: BlogPageableSecureRequest) async throws -> PageableResponse<[BlogResponse]> {
    return try await  sendPageableSecureRequest("latest", blogRequest)
  }
  
  private func sendPageableSecureRequest(
    _ endpoint: String,
    _ blogRequest: BlogPageableSecureRequest,
    method: String = "GET"
  ) async throws -> PageableResponse<[BlogResponse]> {
    let url = URL(string: baseUrl + "/\(endpoint)/\(blogRequest.page)/\(blogRequest.size)")!
    let request = buildRequestBody(url: url, token: blogRequest.token, method: method)
    
    let (data, status) = try await URLSession.shared.data(for: request)
    let httpResponse = status as? HTTPURLResponse
    
    return try await mapResponseToApplicationObject(response: httpResponse, data: data)
  }
  
  private func buildRequestBody(url: URL, token: String, method: String) -> URLRequest {
    var request = URLRequest(url: url)
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = method
    
    return request
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
