//
//  TestModel.swift
//  RemoteDatasource
//
//  Created by Filip Kisić on 24.03.2025..
//
import Foundation

public class URLRequestBuilder {
  var request: URLRequest
  
  init(url: URL) {
    self.request = URLRequest(url: url)
  }
  
  func setAuthorization(token: String, method: String) -> URLRequestBuilder {
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.httpMethod = method
    return self
  }
  
  func setBody(data: Data?) -> URLRequestBuilder {
    if (data != nil) {
      request.httpBody = data
    }
    return self
  }
  
  func build() -> URLRequest {
    return request
  }
}
