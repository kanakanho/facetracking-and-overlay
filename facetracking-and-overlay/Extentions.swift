//
//  Extentions.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/31.
//

import Foundation

extension Dictionary {
    func mapKeys<T>(_ transform: (Key) throws -> T) rethrows -> [T: Value] where T: Hashable {
        var newDict: [T: Value] = [:]
        for (key, value) in self {
            newDict[try transform(key)] = value
        }
        return newDict
    }
}

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter.string(from: self)
    }
}

