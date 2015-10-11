//
//  Extension.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 07/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import Foundation
import UIKit


/// UIColor extension to the pallete color of the app
extension UIColor{
    
    class func greenUnfatify() -> UIColor{
        return UIColor(red: CGFloat(69/255.0), green: CGFloat(202/255.0), blue: CGFloat(181/255.0), alpha: 1)
    }
    
    class func grayUnfatify() -> UIColor {
        return UIColor(red: CGFloat(150/255.0), green: CGFloat(150/255.0), blue: CGFloat(150/255.0), alpha: 1)
    }
    
    class func lightGreenUnfatify() -> UIColor {
        return UIColor(red: CGFloat(139/255.0), green: CGFloat(225/255.0), blue: CGFloat(166/255.0), alpha: 1)
    }

    class func orangeUnfatify() -> UIColor{
        return UIColor(red: CGFloat(255/255.0), green: CGFloat(144/255.0), blue: CGFloat(9/255.0), alpha: 1)
    }
    
    class func redUnfatify() -> UIColor{
        return UIColor(red: CGFloat(228/255.0), green: CGFloat(68/255.0), blue: CGFloat(36/255.0), alpha: 1)
    }
    
    class func redLightUnfatify() -> UIColor{
        return UIColor(red: CGFloat(242/255.0), green: CGFloat(31/255.0), blue: CGFloat(64/255.0), alpha: 1)
    }
    
    class func yellowUnfatify() -> UIColor{
        return UIColor(red: CGFloat(244/255.0), green: CGFloat(159/255.0), blue: CGFloat(23/255.0), alpha: 1)
    }
    
}

extension UITextField{
    
    func charactersInRange(range: Int) -> Bool{
        return self.text?.characters.count >= range
    }
    
    func containsCharacter(character: String) -> Bool{
        return (self.text?.containsString(character))!
    }
    
}

extension UIAlertController{
    
    class func basicMessage(title:String, message:String) -> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let OkAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OkAction)
        return alertController
    }
}


extension NSDate{
    
    func dateToString(formatString: String) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = formatString
        let calendar = NSCalendar.currentCalendar()
//        let compHour = calendar.component(NSCalendarUnit.Hour, fromDate: self)
//        let compMinute = calendar.component(NSCalendarUnit.Minute, fromDate: self)
//        let compHour = calendar.component(NSCalendarUnit.Minute, fromDate: self)

        let date = calendar.dateBySettingHour(0, minute: 0, second: 0, ofDate: self, options: NSCalendarOptions.MatchNextTimePreservingSmallerUnits)
        
        return  formatter.stringFromDate(date!) //calendar.dateFromComponents(components) //formatter.stringFromDate(self)
    }
    
    
     func dateToString() -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'" //"yyyy-MM-dd'T'HH:mm:ss:SSSZ"
        return formatter.stringFromDate(self)
     }
    
    func stringToDate(dateString: String) -> NSDate{
        let formatter = NSDateFormatter()
        formatter.dateFormat =  "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'" //"yyyy-MM-dd'T'HH:mm:ss:SSSZ"
        return formatter.dateFromString(dateString)!
    }
    
    func hour() -> Int{
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.component(NSCalendarUnit.Hour, fromDate: self)
        return comp
    }
    
    func minute() -> Int{
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.component(NSCalendarUnit.Minute, fromDate: self)
        return comp
    }
}


