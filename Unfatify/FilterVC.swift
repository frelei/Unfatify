//
//  FilterVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 10/11/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class FilterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: MESSAGE
    let messageTitle = "Unfatify"
    let messageField = "Fields need to be fill"
    let messageServer = "Ops!!! Unable to connect to server"
    let messageDate = "First date is greather than secount"
    
    // MARK: ATTRIBUTE
    var user: User?
    var meals = NSMutableArray()
    var selectedRow = 0
    var fromDate: NSDate? = NSDate()
    var toDate: NSDate? = NSDate()
    
    var datePicker:UIDatePicker?
    
    // MARK: IBOUTLET
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.tableFooterView = UIView(frame: CGRectZero)
        }
    }
    
    
    // MARK: LIFE CYCLE VC
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: IBACTION
    @IBAction func touchBack(sender: UIButton) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func touchSearch(sender: UIButton) {
        guard let fromDate = self.fromDate where self.fromDate != nil
            else {
                let  alertController = UIAlertController.basicMessage(self.messageTitle, message: self.messageField)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
        }
        guard let toDate = self.toDate where self.toDate != nil
            else {
                let  alertController = UIAlertController.basicMessage(self.messageTitle, message: self.messageField)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
        }
        
        if fromDate.isGreaterThanDate(toDate){
            let  alertController = UIAlertController.basicMessage(self.messageTitle, message: self.messageDate)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        let query = Query()
        query.addDateGte(fromDate.dateToString(), column: "createdAt")
        query.addDateLte(toDate.dateToString(), column: "createdAt")
        let queryData = query.getQueryEncoded()
        let parseAPI = ParseAPI()
        parseAPI.queryObjects("UserMeal?"+queryData, whereClause: nil,
            success: { (data) -> Void in
                self.meals =  NSMutableArray(array: data as! NSArray)
                self.tableView.reloadSections(NSIndexSet.init(index: 1), withRowAnimation: UITableViewRowAnimation.Middle)
            }) { (error) -> Void in
                let  alertController = UIAlertController.basicMessage(self.messageTitle, message: self.messageServer)
                self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: TABLEVIEW DELEGATE
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return 2
        }else{
            return self.meals.count 
        }
    }

    internal func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2;
    }
    
    internal func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return CGFloat(20)
    }
    
    internal func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if section == 0{
            return "Dates"
        }else{
            return "Result"
        }
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if indexPath.section == 1{
        
            let cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath)
            let meal = UserMeal.jsonToUserMeal(meals[indexPath.row] as! [String:AnyObject])
            
            // Set value to view
            let viewIndicator = cell.viewWithTag(1)
            switch meal.calorie!.integerValue {
            case 1...100:
                viewIndicator?.backgroundColor = UIColor.greenUnfatify()
            case 101...200:
                viewIndicator?.backgroundColor = UIColor.yellowUnfatify()
            default:
                viewIndicator?.backgroundColor = UIColor.redLightUnfatify()
            }
            
            // Set value to name
            let lblFood = cell.viewWithTag(2) as! UILabel
            lblFood.text = meal.name
            
            // Set value calorie
            let lblCalorie = cell.viewWithTag(3) as! UILabel
            lblCalorie.text = "\(meal.calorie!.integerValue) kcal"
            
            // Set value for hour
            let lblHour = cell.viewWithTag(4) as! UILabel
            let mealDate = NSDate().stringToDate(meal.createdAt!)
            lblHour.text = "at \(mealDate.hour())"
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("CELL_DATE", forIndexPath: indexPath)

            // Configure Date Picker
            self.datePicker = cell.viewWithTag(1) as? UIDatePicker
            self.datePicker?.addTarget(self, action: "changePickerValue:", forControlEvents: UIControlEvents.ValueChanged)
            
            // Configure Labels
            let titleDate = cell.viewWithTag(2) as! UILabel
            let date = cell.viewWithTag(3) as! UILabel
        
            if indexPath.row == 0{
                titleDate.text = "from date"
            }else{
                titleDate.text = "to date"
            }
            
            if indexPath.row == 0{
                date.text = self.fromDate?.dateToStringShort()
            }else{
                date.text = self.toDate?.dateToStringShort()
            }
            
            return cell;
        }
    }
    
    
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0{
            if self.selectedRow == indexPath.row{
                self.selectedRow = -1
            }else{
                self.selectedRow = indexPath.row
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if indexPath.section == 0{
            if indexPath.row == self.selectedRow{
                return 204
            }else{
                return 68
            }
        }
        return 68
    }
    
    // MARK: DATEPICKER CHANGE
    
    func changePickerValue(sender: UIDatePicker){
        if self.selectedRow == 0{
            self.fromDate = sender.date
        }else if self.selectedRow == 1{
            self.toDate = sender.date
        }
        self.tableView.reloadData()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
