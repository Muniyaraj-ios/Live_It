//
//  UIDate+Extension.swift
//  Live It
//
//  Created by Muniyaraj on 22/08/24.
//

import UIKit

enum DateFormat: String {
    case dayMonthYear = "dd MMM yyyy" // Example format "19 Jan 2005"
    case yearMonthDay = "yyyy-MM-dd" // Example format "2005-01-19"
    case fullDateTime = "dd MMM yyyy HH:mm:ss" // Example format "19 Jan 2005 14:25:30"
    
    // Method to get the formatted date string
    func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent formatting
        return dateFormatter.string(from: date)
    }
}
