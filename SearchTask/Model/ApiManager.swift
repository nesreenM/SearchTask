//
//  ApiManager.swift
//  SearchTask
//
//  Created by Nesreen Mamdouh on 12/12/17.
//  Copyright © 2017 dlc. All rights reserved.
//

import Foundation


public class APIManager {
    
    
    var errorMessage = ""
    var GETResponseDictinary = [String : Any]()
    
    func getRequest(_ method: String, parameters: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError? , _ statusCode:Int) -> Void){
        
        var urlString = "https://autocomplete.clearbit.com/v1/companies/suggest?query=:"
        //URL Parameters
        if !parameters.isEmpty {
            
            urlString += parameters
        }

        let session = URLSession.shared
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        let url = URL(string:  urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = session.dataTask(with: request as URLRequest){ data, response, error in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo), 7)
            }
            if let statusCode = ((response as? HTTPURLResponse)?.statusCode)
            {
                self.convertDataWithCompletionHandler(data!, statusCode: statusCode, completionHandlerForConvertData: completionHandlerForGET)
            }
        }
        
        //End of getRequest Method
        dataTask.resume()
    }
   

    func getImageRequest(url : String ,completionHandlerForGETImage: @escaping (_ result: AnyObject?, _ error: NSError?,_ statusCode : Int) -> Void){
        
        let urlString = url
        let session = URLSession.shared
        let url = URL(string:  urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        
        let dataTask = session.dataTask(with: request as URLRequest){ data, response, error in
            
            if let statusCode = ((response as? HTTPURLResponse)?.statusCode){
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    completionHandlerForGETImage(nil,nil,statusCode)
                    return
                }
                //parse data and use data
                completionHandlerForGETImage(data as AnyObject,nil,statusCode)
            }
        }
        //End of getRequest Method
        dataTask.resume()
    }
    
    
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data,statusCode : Int ,completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError? ,_ statusCode:Int) -> Void) {
        var parsedResult: AnyObject! = nil
        if statusCode >= 200 && statusCode <= 299{
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                
            } catch {
                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
                completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo),statusCode)
                
            }
        }
        
        completionHandlerForConvertData(parsedResult, nil,statusCode)
        
    }
    
    
}
