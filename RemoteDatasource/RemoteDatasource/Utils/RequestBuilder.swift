//
//  TestModel.swift
//  RemoteDatasource
//
//  Created by Filip Kisić on 24.03.2025..
//
import Foundation

public class URLRequestBuilder {
  // MARK: - PROPERTIES
  private var request: URLRequest
  
  // MARK: - CONSTRUCTOR
  init(url: URL) {
    self.request = URLRequest(url: url)
  }
  
  // MARK: - FUNCTIONS
  func setAuthorization(token: String, method: String) -> URLRequestBuilder {
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = method
    return self
  }
  
  func setBody(data: Data?, contentType: String = "application/json") -> URLRequestBuilder {
    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    request.httpBody = data
    return self
  }
  
  func build() -> URLRequest {
    return request
  }
}

// MARK: - DATA EXTENSION
public extension Data {
  mutating func append(_ string: String, encoding: String.Encoding = .utf8) {
    guard let data = string.data(using: encoding) else {
      return
    }
    append(data)
  }
}

