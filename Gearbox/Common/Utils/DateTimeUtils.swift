//
//  DateTimeUtils.swift
//  Gearbox
//
//  Created by Filip Kisić on 10.09.2024..
//

import Foundation

class DateTimeUtils {
  static func formatAsFullDay() -> String {
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

extension Date {
  func formatAsTimePassed() -> String {
    let currentDateTime = Date()
    let difference = Calendar.current.dateComponents(
      [.year, .month, .day, .hour, .minute],
      from: self,
      to: currentDateTime
    )
    
    if (difference.day ?? 0 > 7) {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd.MM.yyyy"
      return formatter.string(from: self)
    }
    
    if (difference.day ?? 0 >= 1) {
      return difference.day == 1 ? "1 day ago" : "\(difference.day!) days ago"
    }
    
    if (difference.hour ?? 0 >= 1) {
      return difference.hour == 1 ? "1 hour ago" : "\(difference.hour!) hours ago"
    }
    
    if (difference.minute ?? 0 >= 1) {
      return difference.minute == 1 ? "1 minute ago" : "\(difference.minute!) minutes ago"
    }
    
    return "Now"
  }
}
