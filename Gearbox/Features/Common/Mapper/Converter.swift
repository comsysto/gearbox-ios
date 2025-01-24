//
//  Mapper.swift
//  Gearbox
//
//  Created by Filip Kisić on 04.08.2024..
//

import Foundation

protocol ConverterType  {
  associatedtype Source
  associatedtype Target
  
  func convert(_ from: Source) -> Target
}
