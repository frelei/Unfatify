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
    case GET,POST,PUT,DELETE
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
        }
    }
}
