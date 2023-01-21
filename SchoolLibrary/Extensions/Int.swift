//
//  Int.swift
//  SchoolLibrary
//
//  Created by Radi on 21.01.23.
//

import Foundation

extension Int {
    func timestampToDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.dateFormat = "EEEE, MMM d, yyyy, HH:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateString = formatter.string(from: date)

        return dateString
    }
}
