//
//  QuickSearchViewController.swift
//  SearchTask
//
//  Created by Nesreen Mamdouh on 12/12/17.
//  Copyright © 2017 dlc. All rights reserved.
//

import UIKit
import SearchTextField
class QuickSearchViewController: UIViewController,NetworkRequestCompletionHandler {
  

    @IBOutlet weak var domainImageView: UIImageView!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var searchTextField: SearchTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeSearchTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customizeSearchTextField(){

        searchTextField.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            print("Filtered results " ,filteredResults.count)
            print("Item at position \(itemPosition): \(item.title)")
            
            // Do whatever you want with the picked item
            self.searchTextField.text = item.title
            self.nameLabel.text = item.title
            self.domainLabel.text = DataModel.sharedInstance.dataDictionary[item.title]?[0]
            let url =  DataModel.sharedInstance.dataDictionary[item.title]?[1]
            NetworkRequests().getProductImage(url: url!,completionHandlerGetProductImage: {
                data in
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                            self.domainImageView.image = image
                    }
                }
                else{
//                    self.domainImageView.image = UIImage(named: "image-not-available")
                }
            })
            
        }
        searchTextField.userStoppedTypingHandler = {
            if let criteria = self.searchTextField.text {
                if criteria.characters.count > 1 {
                    
                    // Show loading indicator
                    self.searchTextField.showLoadingIndicator()
                    NetworkRequests().getSearchResults(query: criteria, sender: self)
                }
            }
            } as (() -> Void)
    }
    func onComplete(_ methodName: String) {
        print("On complete " , DataModel.sharedInstance.results.count)
        self.searchTextField.filterItems(DataModel.sharedInstance.results)
        
        self.searchTextField.stopLoadingIndicator()
        
    }
    
    func onError(_ methodName: String) {
        print("ERROR")
    }
    

}
