//
//  Date + Extension.swift
//  TEST2
//
//  Created by Ulan Nurmatov on 08.11.2021.
//

import Foundation

extension Date {
    
    func getFormattedDateForUser() -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd.MM.yyyy"
        return dateformat.string(from: self)
    }
}

