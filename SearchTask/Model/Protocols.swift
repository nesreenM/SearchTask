//
//  Protocols.swift
//  SearchTask
//
//  Created by Nesreen Mamdouh on 12/12/17.
//  Copyright © 2017 dlc. All rights reserved.
//

import Foundation


protocol NetworkRequestCompletionHandler {
    func onComplete(_ methodName : String)
    func onError(_ methodName : String)
}
