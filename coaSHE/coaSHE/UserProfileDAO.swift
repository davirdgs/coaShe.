//
//  UserProfileDAO.swift
//  coaSHE
//
//  Created by Davi Rodrigues on 08/01/16.
//  Copyright © 2016 Carolina Bonturi. All rights reserved.
//

import UIKit

class UserProfileDAO: NSObject {

    static func persistUserInfo() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setObject(UserProfileInfo.name, forKey: "name")
        defaults.setObject(UserProfileInfo.email, forKey: "email")
        defaults.setObject(UserProfileInfo.id, forKey: "id")
        defaults.setObject(UserProfileInfo.headLine, forKey: "headline")
        defaults.setObject(UserProfileInfo.summary, forKey: "summary")
        defaults.setObject(UserProfileInfo.pictureUrl, forKey: "pictureUrl")
        
        let table = SkillTable.convertTableToArray()
        defaults.setObject(table, forKey: "skill")
        
        let days = Schedule.days
        defaults.setObject(days, forKey: "days")
        
        let time = Schedule.timeToArray()
        defaults.setObject(time, forKey: "time")
        
        defaults.synchronize()
    }
    
    static func loadUserInfo() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if((defaults.objectForKey("days")) != nil) {
            let days = defaults.objectForKey("days") as! [Bool]
            Schedule.days = days
        }
        /*
        if((defaults.objectForKey("time")) != nil) {
            let time = defaults.objectForKey("time") as! NSArray
            Schedule.arrayToTime(time)
        }
        */
        if(defaults.objectForKey("skill") != nil) {
            let table = defaults.objectForKey("skill") as! NSArray
            SkillTable.convertArrayToTable(table)
        } else {
            SkillTable.setSkillTable()
        }
        
        if(defaults.objectForKey("name") != nil) {
            UserProfileInfo.name = defaults.objectForKey("name") as! String
        }
        if(defaults.objectForKey("email") != nil) {
            UserProfileInfo.email = defaults.objectForKey("email") as! String
        }
        if(defaults.objectForKey("id") != nil) {
            UserProfileInfo.id = defaults.objectForKey("id") as! String
        }
        if(defaults.objectForKey("headline") != nil) {
            UserProfileInfo.headLine = defaults.objectForKey("headline") as! String
        }
        if(defaults.objectForKey("summary") != nil) {
            UserProfileInfo.summary = defaults.objectForKey("summary") as! String
        }
        if(defaults.objectForKey("pictureUrl") != nil) {
            UserProfileInfo.pictureUrl = defaults.objectForKey("pictureUrl") as! String
            let dat = NSData(contentsOfURL: NSURL(string: "pictureUrl")!)
            if(dat != nil) {
                dispatch_sync(dispatch_get_main_queue(), {
                    UserProfileInfo.profileImage = UIImage(data: dat!)
                })
            }
        }
        
    }

    
}
