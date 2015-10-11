//
//  CalorieVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 07/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class CalorieVC: UIViewController, UITableViewDelegate, UITableViewDataSource, EntryDelegate {

    // MARK: MESSAGES
    let messageTitle = "Unfatify"
    let messageDelete = "Ops!!! Error to delete entry"
    let messageServer = "Ops!!! Unable to connect to server"
    
    // MARK: ATTRIBUTES
    var user: User?
    var meals = NSMutableArray()
    
    // MARK: IBOUTLET
    @IBOutlet weak var tableView: UITableView!{
        didSet{ tableView.delegate = self; tableView.dataSource = self }
    }
    
    @IBOutlet weak var lblEaten: UILabel!
    @IBOutlet weak var lblKcalLeft: UILabel!
    @IBOutlet weak var lblExcceded: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    // MARK: LIFE CYCLE VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keychainService = KeychainService()
        let token = keychainService.getToken()
        user = User.currentUser(token!)
        
        self.loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    // MARK: LOAD DATA
    func loadData(){
        // Create Date
        let cal: NSCalendar = NSCalendar.currentCalendar()
        let newDate = cal.dateBySettingHour(0, minute: 0, second: 0, ofDate: NSDate(), options: NSCalendarOptions())!
        // Create Query
        let query = Query()
        query.addPointer("_User", objectId: (user?.objectID)!, column: "user")
        query.addDateGte( newDate.dateToString() , column: "createdAt")
        
        let queryData = query.getQuery().stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        let parseAPI = ParseAPI()
        parseAPI.queryObjects("UserMeal?"+queryData, whereClause: nil,
            success: { (data) -> Void in
                self.meals =  NSMutableArray(array: data as! NSArray)
                self.tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: UITableViewRowAnimation.Middle)
            }, failure: { (error) -> Void in
                let  alertController = UIAlertController.basicMessage(self.messageTitle, message: self.messageServer)
                self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    // TODO: RELOAD
    
    
    
    // MARK: TABLEVIEW DELEGATE
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return meals.count;
    }

    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath)
        let meal =  UserMeal.jsonToUserMeal(meals[indexPath.row] as! [String:AnyObject])
        
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
    }
    
    
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    internal func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete")
            { (UITableViewRowAction, NSIndexPath) -> Void in
                let meal =  UserMeal.jsonToUserMeal(self.meals[indexPath.row] as! [String:AnyObject])
                let parseAPI = ParseAPI()
                parseAPI.deleteObject("UserMeal", objectId: meal.objectId!, data: nil, success: { (data) -> Void in
                        tableView.reloadData()
                    }, failure: { (error) -> Void in
                        let  alertController = UIAlertController.basicMessage(self.messageTitle, message: self.messageDelete)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    })
            }
        
        return [deleteAction]
    }
    
    internal func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

    // MARK: IBACTIONS
    
    @IBAction func touchAddMeal(sender: AnyObject) {
        self.performSegueWithIdentifier("goToEntry", sender: user)
    }
    
    
    @IBAction func touchProfile(sender: UIButton) {
        self.performSegueWithIdentifier("goToSetting", sender: self.user)
    }
    
    
    // MARK: ENTRY DELEGATE
    func entryDidFinish(entryVC: EntryVC, result: Bool) {
        entryVC.dismissViewControllerAnimated(true, completion: nil)
        if result{
            self.loadData()
        }
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToEntry"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let entryVC = navigationController.viewControllers.first as! EntryVC
            entryVC.delegate = self
            entryVC.user = sender as? User
        }else{
            let settingVC = segue.destinationViewController as! SettingVC
            settingVC.user = sender as? User
        }
    }
    

}
