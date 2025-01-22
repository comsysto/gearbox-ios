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
  
  func getTrending(blogRequest: BlogPageableSecureRequest) async throws -> PageableResponse<[BlogResponse]> {
    let url = URL(string: baseUrl + "/trending/0/5")!
    var request = URLRequest(url: url)
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(blogRequest.token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"
    
    let (response, status) = try await URLSession.shared.data(for: request)
    
    let httpResponse = status as? HTTPURLResponse
    
    switch httpResponse?.statusCode {
      case 200:
        let decoder = buildConfiguredDecoder()
        return try decoder.decode(PageableResponse<[BlogResponse]>.self, from: response)
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
