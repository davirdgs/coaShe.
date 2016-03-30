//
//  Schedule.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 07/01/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit

class Schedule: NSObject {

    /// [dom, seg, ter, qua, qui, sex, sab]
    static var days: [Bool] = [false, false, false, false, false, false, false]
    
    /// [hr, min, (até) hr, min]
    static var time: [Int] = [0, 0, 0, 0]
    
    static var schedule: [TimeModel] = [TimeModel]()
    
    static func initTimeModel () {
        let dom = TimeModel()
        let seg = TimeModel()
        let ter = TimeModel()
        let qua = TimeModel()
        let qui = TimeModel()
        let sex = TimeModel()
        let sab = TimeModel()
        
        schedule = [dom, seg, ter, qua, qui, sex, sab]
    }
    
    static func timeToArray() -> NSArray {
        
        let mutableArray = NSMutableArray()
        
        for i in 0...(schedule.count - 1) {
            for j in 0...(schedule[i].selectedHours.count - 1) {
                mutableArray.addObject(schedule[i].selectedHours[j])
            }
        }
        
        return mutableArray as NSArray
    }
    
    static func arrayToTime(array: NSArray) {
        
        var count = 0
        for i in 0...6 {
            for j in 0...23 {
                schedule[i].selectedHours[j] = array[count] as! Bool
                count += 1
            }
        }
        
    }
    
}
