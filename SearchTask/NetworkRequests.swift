//
//  NetworkRequests.swift
//  SearchTask
//
//  Created by Nesreen Mamdouh on 12/12/17.
//  Copyright © 2017 dlc. All rights reserved.
//

import Foundation
import SearchTextField
class NetworkRequests {
    
   func getSearchResults(query:String , sender:NetworkRequestCompletionHandler){
        APIManager().getRequest("", parameters: query, queryParameters: nil, headers: nil, completionHandlerForGET: {
            (result,error,statusCode) in
            if statusCode >= 200 && statusCode <= 299 {
                
                if let dataArray = result as? [[String:Any]] {
                    DataModel.sharedInstance.results.removeAll()
                    DataModel.sharedInstance.dataDictionary.removeAll()
                    for data in dataArray {
                       
                        let itemName = data["name"] as? String ?? ""
                        let itemDomain = data["domain"] as? String ?? ""
                        let itemLogo = data["logo"] as? String ?? ""
                        DataModel.sharedInstance.dataDictionary[itemName] = [itemDomain ,itemLogo]

                        print("Item ", itemName)
                        print("itemDomain ", itemDomain)
                        print("itemLogo ", itemLogo)

                        DataModel.sharedInstance.results.append(SearchTextFieldItem(title: itemName))
                    }
                    print("Data model" , DataModel.sharedInstance.results.count)
                    print("Data model count" , DataModel.sharedInstance.dataDictionary.count)

                    DispatchQueue.main.async {
                        sender.onComplete("getSearchResults")
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        sender.onError("getSearchResults")
                    }
                }
            }
            else{
                DispatchQueue.main.async {
                    sender.onError("getSearchResults")
                }
            }
            
        })
    }
    func getProductImage(url : String,completionHandlerGetProductImage: @escaping  (_ imageData:Data?) -> Void){
        APIManager().getImageRequest(url: url, completionHandlerForGETImage:{
            (data,error,statusCode) in
            if(statusCode >= 200 && statusCode <= 299){
                
                DispatchQueue.main.async {
                    completionHandlerGetProductImage(data as? Data)
                }
            }
            else{
                DispatchQueue.main.async {
                    completionHandlerGetProductImage(nil)
                }
            }
        })
    }
}


protocol NetworkRequestCompletionHandler {
    func onComplete(_ methodName : String)
    func onError(_ methodName : String)
}
