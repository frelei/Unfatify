//
//  ManagerVC.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 10/12/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit

class ManagerVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NewMealDelegate {

    // MARK: MESSAGES
    let messageTitle = "Unfatify"
    let messageDelete = "Ops!!! Error to delete entry"
    let messageServer = "Ops!!! Unable to connect to server"
    
    // MARK: ATTRIBUTES
    var user: User?
    var meals =  NSMutableArray()
    // MARK: IBOUTLETS
    
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
        self.loadData()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: LOAD DATA
    func loadData(){
        
        let query = Query()
        query.addPointer("_User", objectId: (user?.objectID)!, column: "user")
        let queryData = query.getQueryEncoded()
        
        let parseAPI = ParseAPI()
        parseAPI.queryObjects("Meal?"+queryData, whereClause: nil,
            success: { (data) -> Void in
                self.meals =  NSMutableArray(array: data as! NSArray)
                self.tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: UITableViewRowAnimation.Middle)
            }, failure: { (error) -> Void in
                let  alertController = UIAlertController.basicMessage(self.messageTitle, message: self.messageServer)
                self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    // MARK: IBACTIONS
    @IBAction func touchClose(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func touchCreateMeal(sender: UIButton) {
        self.performSegueWithIdentifier("goToManagerMeal", sender: user)
        
    }
    
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
                let keychainService = KeychainService()
                let token = keychainService.getToken()
                let meal =  UserMeal.jsonToUserMeal(self.meals[indexPath.row] as! [String:AnyObject])
                let parseAPI = ParseAPI()
                parseAPI.deleteObject("Meal", token:token!, objectId: meal.objectId!, data: nil, success: { (data) -> Void in
                    self.loadData()
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
    
    // MARK: New Meal Delegate
    func newMealDidFinish(newMeal: NewMealVC, result: Bool){
        newMeal.navigationController?.popViewControllerAnimated(true)
        if result{
            let  alertController = UIAlertController.basicMessage(self.messageTitle, message: newMeal.messagelUpdate)
            self.loadData()
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            let  alertController = UIAlertController.basicMessage(self.messageTitle, message: self.messageDelete)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "goToManagerMeal"{
                let newMeal = segue.destinationViewController as! NewMealVC
                newMeal.delegate = self
                newMeal.user = sender as? User
            }
    }
    

}
