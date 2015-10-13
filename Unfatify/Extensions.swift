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
    
    /**
    Transform the date in string based on Short-Style        
    */
    func dateToStringShort() -> String{
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter.stringFromDate(self)
    }
    
    /**
        Transform the date in string based on format yyy-MM-dd HH:mm:ss
    */
    func dateToString() -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        return formatter.stringFromDate(self)
     }
    
    func stringToDate(dateString: String) -> NSDate{
        let formatter = NSDateFormatter()
        formatter.dateFormat =  "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
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
    
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool{
        var isGreater = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending{
            isGreater = true
        }
        return isGreater
    }
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool{
        var isLess = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending{
            isLess = true
        }
        return isLess
    }

}

extension UIImageView{
    
    func loadImageAsyncFromUrl(url: String?){
        if let picture = url{
            if let url = NSURL(string: picture) {
                let request: NSURLRequest = NSURLRequest(URL: url)
                let mainQueue = NSOperationQueue.mainQueue()
                NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                    if error == nil{
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.image = UIImage(data:data!)
                        })
                    }
                })
            }
        }    
    }
    
}


