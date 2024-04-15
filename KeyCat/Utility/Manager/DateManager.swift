//
//  DateManager.swift
//  KeyCat
//
//  Created by 원태영 on 4/15/24.
//

import Foundation

final class DateManager {
  
  static let shared = DateManager()
  private init() { }
  
  private let locale = Locale(identifier: "ko_KR")
  private let timezone = TimeZone(identifier: "ko_KR")
  
  private lazy var dateFormatter = DateFormatter().configured {
    $0.locale = locale
    $0.timeZone = timezone ?? .autoupdatingCurrent
  }
  
  private lazy var timerFormatter = DateFormatter().configured {
    $0.locale = locale
    $0.timeZone = TimeZone(secondsFromGMT: .zero)
  }
  
  private lazy var isoDateFormaater = ISO8601DateFormatter().configured {
    $0.timeZone = timezone ?? .autoupdatingCurrent
    $0.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
  }
  
  private lazy var calendar = Calendar.current.applied {
    $0.locale = locale
    $0.timeZone = timezone ?? .autoupdatingCurrent
  }
}

extension DateManager {
  
  enum Format: String {
    case HHmm = "HH:mm"
    case HHmmss = "HH:mm:ss"
    case HHmmssKR = "HH시간 mm분 ss초"
    case HHmmssTimeOfDayKR = "HH시 mm분 ss초"
    case HHKr = "HH시"
    case EEEE = "EEEE"
    case yyyyMMdd = "yyyyMMdd"
    case yyyyMMddKR = "yyyy년 MM월 dd일"
    case yyyyMMddEEEEKR = "yyyy년 MM월 dd일 EEEE"
    
    var format: String {
      return self.rawValue
    }
  }
}

// MARK: - String Format
extension DateManager {
  
  func isoStringtoDate(with string: String) -> Date {
    guard let date = isoDateFormaater.date(from: string) else {
      return Date()
    }
    
    return date
  }
  
  func toString(with date: Date, format: Format) -> String {
    dateFormatter.dateFormat = format.format
    
    return dateFormatter.string(from: date)
  }
  
  func toString(with date: Date, formatString: String) -> String {
    dateFormatter.dateFormat = formatString
    
    return dateFormatter.string(from: date)
  }
  
  func toString(with interval: TimeInterval, format: Format) -> String {
    dateFormatter.dateFormat = format.format
    
    return dateFormatter.string(from: Date(timeIntervalSince1970: interval))
  }
  
  func toString(with interval: TimeInterval, formatString: String) -> String {
    dateFormatter.dateFormat = formatString
    
    return dateFormatter.string(from: Date(timeIntervalSince1970: interval))
  }
  
  func toString(with duration: Int, format: Format) -> String {
    dateFormatter.dateFormat = format.format
    
    return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(duration)))
  }
  
  func toString(with duration: Int, formatString: String) -> String {
    dateFormatter.dateFormat = formatString
    
    return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(duration)))
  }
  
  func elapsedTime(_ date: Date, format: Format) -> String {
    let elapsedTime = Date().timeIntervalSince(date)
    let intervalToDate = Date(timeIntervalSince1970: elapsedTime)
    
    timerFormatter.dateFormat = format.format
    return timerFormatter.string(from: intervalToDate)
  }
  
  func elapsedTime(_ date: Date, formatString: String) -> String {
    let elapsedTime = Date().timeIntervalSince(date)
    let intervalToDate = Date(timeIntervalSince1970: elapsedTime)
    
    timerFormatter.dateFormat = formatString
    return timerFormatter.string(from: intervalToDate)
  }
  
  func elapsedTime(_ interval: TimeInterval, format: Format) -> String {
    let intervalToDate = Date(timeIntervalSince1970: interval)
    
    timerFormatter.dateFormat = format.format
    return timerFormatter.string(from: intervalToDate)
  }
  
  func elapsedTime(_ interval: TimeInterval, formatString: String) -> String {
    let intervalToDate = Date(timeIntervalSince1970: interval)
    
    timerFormatter.dateFormat = formatString
    return timerFormatter.string(from: intervalToDate)
  }
  
  func elapsedTime(_ duration: Int, format: Format) -> String {
    let intervalToDate = Date(timeIntervalSince1970: TimeInterval(duration))
    
    timerFormatter.dateFormat = format.format
    return timerFormatter.string(from: intervalToDate)
  }
  
  func elapsedTime(_ duration: Int, formatString: String) -> String {
    let intervalToDate = Date(timeIntervalSince1970: TimeInterval(duration))
    
    timerFormatter.dateFormat = formatString
    return timerFormatter.string(from: intervalToDate)
  }
  
  func unixTimestampToString(with interval: TimeInterval, format: Format) -> String {
    dateFormatter.dateFormat = format.format
    
    return dateFormatter.string(from: Date(timeIntervalSince1970: interval))
  }
}

// MARK: - Compare Date
extension DateManager {
  
  func getDateBetween(when date: Date, by day: Int = 1) -> (start: Date, end: Date) {
    let start = calendar.startOfDay(for: date)
    let end = calendar.date(byAdding: .day, value: day, to: start) ?? Date()
    
    return (start, end)
  }
}

// MARK: - Compare Date
extension DateManager {
  
  func isDate(with interval: TimeInterval, by component: Calendar.Component, equalTo: Int) -> Bool {
    return calendar.component(component, from: Date(timeIntervalSince1970: interval)) == equalTo
  }
  
  func isDate(with date: Date, by component: Calendar.Component, equalTo: Int) -> Bool {
    return calendar.component(component, from: date) == equalTo
  }
  
  func isDate(with date: Date, by component: Calendar.Component..., equalTo: Int...) -> Bool {
    let min = min(component.count, equalTo.count)
    
    return !(0..<min)
      .map { calendar.component(component[$0], from: date) == equalTo[$0] }
      .contains(false)
  }
}

