//
//  Date+Today.swift
//  OnlySwitch
//
//  Created by Jacklandrin on 2022/8/12.
//

import Foundation
extension Date {
    func date(at hours: Int, minutes: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        
        //get the month/day/year componentsfor today's date.
        
//        print("Now = \(self)")
        var dateComponents = calendar.dateComponents([.year,.month,.day], from: self)
        
        dateComponents.hour = hours
        dateComponents.minute = minutes
        dateComponents.second = 0
        
        let newDate = calendar.date(from: dateComponents)!
        return newDate
    }
}
