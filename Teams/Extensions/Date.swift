//
//  Date.swift
//  Teams
//
//  Created by Shyam Kumar on 1/2/23.
//

import Foundation

extension Date {
    var composed: Int {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return (components.year! * 365) + (components.month! * 30) + (components.day!)
    }
}
