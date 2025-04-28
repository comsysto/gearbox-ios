//
//  MultipartRequest.swift
//  RemoteDatasource
//
//  Created by Filip Kisić on 17.04.2025..
//
import Foundation


public class MultipartRequest {
  // MARK: - PROPERTIES
  private let boundary: String
  private let separator: String = "\r\n"
  private var data: Data
  
  // MARK: - CONSTRUCTOR
  init(boundary: String = UUID().uuidString) {
    self.boundary = boundary
    self.data = .init()
  }
  
  // MARK: - FUNCTIONS
  func addPair(key: String, value: String) -> Self {
    appendBoundarySeparator()
    data.append(disposition(key) + separator)
    appendSeparator()
    data.append(value + separator)
    
    return self
  }
  
  func addFile(key: String, fileName: String, imageData: Data) -> Self{
    appendBoundarySeparator()
    data.append(disposition(key) + "; filename=\"\(fileName)\"" + separator)
    appendSeparator()
    data.append(imageData)
    appendSeparator()
    
    return self
  }
  
  func build() -> Data {
    appendBoundarySeparator()
    return data
  }
  
  private func appendBoundarySeparator() {
    data.append("--\(boundary)\(separator)")
  }
  
  private func appendSeparator() {
    data.append(separator)
  }
  
  private func disposition(_ key: String) -> String {
    return "Content-Disposition: form-data; name=\"\(key)\""
  }
}

