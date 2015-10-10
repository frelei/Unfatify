//
//  WebService.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 05/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit
import Alamofire

/// WebServiceConnectionType represents the type(verb) of the HTTP connetion
enum WebServiceConnectionType{
    case GET,POST,PUT,DELETE,GET_SYNC
}

/// WebService is the class responsable for HTTP request to a Restful API
class WebService {

    typealias WebServiceSuccess = (JSON: AnyObject?) -> Void
    typealias WebServiceFailure = (ERROR: AnyObject?) -> Void
    
    /**
    Perform a HTTP connection
        -@Parameter type: Send a method GET, POST, PUT, DELETE
        -@Parameter url:  The path for the connection
        -@Parameter params: Aditional values to send on the request
        -@Parameter header: Aditional values to put on the header of the request
        -@Parameter success: Closure that send the response of the request
        -@Parameter erro: Closure that send the error of the request
    */
    func connection(typeConnection: WebServiceConnectionType, url: String, params: [String:AnyObject]?, header: [String:String], success: WebServiceSuccess, failure: WebServiceFailure){
        
        switch typeConnection{
        case .GET:
              Alamofire.request(.GET, url, parameters: params, encoding: .JSON, headers: header)
                    .responseJSON(completionHandler: { (response) -> Void in
                        let result = response.result
                            if result.isSuccess{
                                let json = result.value as! [String: AnyObject]
                                if let _ = json["error"]{
                                    failure(ERROR: json)
                                }else{
                                    success(JSON: json)
                                }

                            }else{
                                failure(ERROR: ["error":"Occured an error"])
                            }
                    })
            
        case .POST:
            Alamofire.request(.POST, url, parameters: params, encoding: .JSON, headers: header)
                .responseJSON(completionHandler: { (response) -> Void in
                    let result = response.result
                    if result.isSuccess{
                        let json = result.value as! [String: AnyObject]
                        if let _ = json["error"]{
                            failure(ERROR: json)
                        }else{
                            success(JSON: json)
                        }
                        
                    }else{
                        failure(ERROR: ["error":"Occured an error"])
                    }
                })
 
            
        case .PUT:
             Alamofire.request(.PUT, url, parameters: params, encoding: .JSON, headers: header)
                .responseJSON(completionHandler: { (response) -> Void in
                    let result = response.result
                    if result.isSuccess{
                        let json = result.value as! [String: AnyObject]
                        if let _ = json["error"]{
                            failure(ERROR: json)
                        }else{
                            success(JSON: json)
                        }
                        
                    }else{
                        failure(ERROR: ["error":"Occured an error"])
                    }
                })
            
        case .DELETE:
            Alamofire.request(.DELETE, url, parameters: params, encoding: .JSON, headers: header)
                .responseJSON(completionHandler: { (response) -> Void in
                    let result = response.result
                    if result.isSuccess{
                        let json = result.value as! [String: AnyObject]
                        if let _ = json["error"]{
                            failure(ERROR: json)
                        }else{
                            success(JSON: json)
                        }
                        
                    }else{
                        failure(ERROR: ["error":"Occured an error"])
                    }
                })
        case .GET_SYNC:
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "GET"
            for (key,value) in header{
                request.setValue(value, forHTTPHeaderField: key)
            }
            let semaphore = dispatch_semaphore_create(0)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if error == nil{
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
                        dispatch_semaphore_signal(semaphore)
                        if json["error"] == nil{
                            success(JSON: json)
                        }else{
                            failure(ERROR: json)
                        }
                    }catch _ {
                        dispatch_semaphore_signal(semaphore)
                        failure(ERROR: ["error" : "Error parsing"])
                    }
                }else{
                    dispatch_semaphore_signal(semaphore)
                    failure(ERROR: ["error" : "Error data"])
                }
                
            })
            task.resume()
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    }
}
