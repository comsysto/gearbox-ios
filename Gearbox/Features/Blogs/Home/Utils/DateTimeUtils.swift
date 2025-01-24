//
//  DateTimeUtils.swift
//  Gearbox
//
//  Created by Filip Kisić on 10.09.2024..
//

import Foundation

class DateTimeUtils {
  static func getFormattedDay() -> String {
    let currentDate = Date()
    let formatter = DateFormatter()
    
    formatter.dateFormat = "EEEE, MMMM"
    let formattedDate = formatter.string(from: currentDate)
    
    let day = Calendar.current.component(.day, from: currentDate)
    let suffix = daySuffix(for: day)
    
    return "\(formattedDate) \(day)\(suffix)"
  }
  
  static func daySuffix(for day: Int) -> String {
    return switch day {
      case 1, 21, 31:
        "st"
      case 2, 22:
        "nd"
      case 3, 23:
        "rd"
      default:
        "th"
    }
  }
}
