//
//  DataModel.swift
//  SearchTask
//
//  Created by Nesreen Mamdouh on 12/12/17.
//  Copyright © 2017 dlc. All rights reserved.
//

import Foundation
import SearchTextField

class DataModel {
    static let sharedInstance = DataModel()
    var results = [SearchTextFieldItem]()
    var dataDictionary : [String:[String]] = [:]
    private init(){
        
    }
    
}
