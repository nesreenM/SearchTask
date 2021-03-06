//
//  QuickSearchViewController.swift
//  SearchTask
//
//  Created by Nesreen Mamdouh on 12/12/17.
//  Copyright © 2017 dlc. All rights reserved.
//

import UIKit
import SearchTextField
import SystemConfiguration

class QuickSearchViewController: UIViewController,NetworkRequestCompletionHandler {
  

    @IBOutlet weak var activityIndictor: UIActivityIndicatorView!
    @IBOutlet weak var domainImageView: UIImageView!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var searchTextField: SearchTextField!
    var reachability =  Reachability()!
    var networkLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        searchTextField.layer.borderColor = UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 18)!]
        customizeSearchTextField()
        textFieldElasticSearch()
        self.hideKeyboardWhenTappedAround()
        activityIndictor.activityIndicatorViewStyle = .gray
        activityIndictor.stopAnimating()
        networkLabel = displayNetworkLabel()
        addReachabilityObserver(reachability: reachability)
        self.view.addSubview(networkLabel)
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataModel.sharedInstance.dataDictionary.removeAll()
        DataModel.sharedInstance.results.removeAll()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func internetChanged(note: Notification) {
        let reachability = note.object as! Reachability
        if(reachability.connection != .none){
            networkLabel.removeFromSuperview()
        }else {
            print("No internet")
            self.view.addSubview(networkLabel)
        }
    }
    func customizeSearchTextField(){
        searchTextField.theme.bgColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        searchTextField.theme.borderColor = UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        searchTextField.theme.fontColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
    }
    
    func textFieldElasticSearch(){
        
        searchTextField.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.dismissKeyboard()
            self.searchTextField.text = item.title
            self.nameLabel.text = item.title
            self.domainLabel.text = DataModel.sharedInstance.dataDictionary[item.title]?[0]
            let url =  DataModel.sharedInstance.dataDictionary[item.title]?[1]
            self.activityIndictor.startAnimating()
            self.domainImageView.image = UIImage()
            NetworkRequests().getProductImage(url: url!,completionHandlerGetProductImage: {
                data in
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.activityIndictor.stopAnimating()

                        UIView.transition(with: self.domainImageView, duration: 0.8, options: .transitionFlipFromTop, animations: {
                                self.domainImageView.image = image
                        }, completion: nil)
                        
                    }
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
        self.searchTextField.filterItems(DataModel.sharedInstance.results)
        self.searchTextField.stopLoadingIndicator()
        
    }
    
    func onError(_ methodName: String) {
        print("ERROR")
    }
    

}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
