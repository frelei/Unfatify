//
//  WebService.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 05/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit
import AFNetworking


/// WebServiceConnectionType represents the type(verb) of the HTTP connetion
enum WebServiceConnectionType{
    case GET,POST,PUT,DELETE
}

/// WebService is the class responsable for HTTP request to a Restful API
class WebService {

    typealias WebServiceSuccess = (JSON: AnyObject?) -> Void
    typealias WebServiceFailure = (ERROR: NSError?) -> Void
    
    /**
    Perform a HTTP connection
        -@Parameter type: Send a method GET, POST, PUT, DELETE
        -@Parameter url:  The path for the connection
        -@Parameter params: Aditional values to send on the request
        -@Parameter header: Aditional values to put on the header of the request
        -@Parameter success: Closure that send the response of the request
        -@Parameter erro: Closure that send the error of the request
    */
    func connection(typeConnection: WebServiceConnectionType, url: String, params: [String:String], header: [String:String], success: WebServiceSuccess, failure: WebServiceFailure){
        
        let manager = AFHTTPRequestOperationManager()
        
        // Add parameters to the request
        for(key,value) in header{
            manager.requestSerializer.setValue(value, forHTTPHeaderField: key)
        }
        
        switch typeConnection{
        case .GET:
            manager.GET(url, parameters: params, success: { (requestOperation, response) -> Void in
                    success(JSON: response)
                }, failure: { (requestOperation, error) -> Void in
                    failure(ERROR: error)
            })
            
        case .POST:
            manager.POST(url, parameters: params, success: { (requestOperation, response) -> Void in
                    success(JSON:response)
                }, failure: { (requestOperation, error) -> Void in
                    failure(ERROR:error)
            })
            
        case .PUT:
            manager.PUT(url, parameters: params, success: { (requestOperation, response) -> Void in
                    success(JSON: response)
                }, failure: { (requestOperation, error) -> Void in
                    failure(ERROR:error)
            })
            
        case .DELETE:
            manager.DELETE(url, parameters: params, success: { (requestOperation, response) -> Void in
                    success(JSON: response)
                }, failure: { (requestOperation, error) -> Void in
                    failure(ERROR: error)
            })
        }
    }
    
    
}
