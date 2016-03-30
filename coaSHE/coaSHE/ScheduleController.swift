//
//  ScheduleController.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 07/01/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit

class ScheduleController: NSObject {

    static func validTime(array: NSArray) -> Bool{
        
        let date = NSDate()
        let dateFormater = NSDateFormatter()
        
        dateFormater.dateFormat = "HH:mm"
        
        let currentTime = dateFormater.stringFromDate(date)
        let currentTimeArr = currentTime.characters.split{$0==":"}.map(String.init)
        
        let currentHour: Int = Int(currentTimeArr[0])!
        let day = getDayOfWeek()
        
        return array[currentHour + (24*day)] as! Bool
    }
    
    // Deprecated
    static func getDayOfWeek() -> Int {
        
        let date = NSDate()
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.dateFromString(formatter.stringFromDate(date))!
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(NSCalendarUnit.Weekday, fromDate: todayDate)
        let weekDay = myComponents.weekday - 1
        
        //return Schedule.days[weekDay]
        return weekDay
    }


}
