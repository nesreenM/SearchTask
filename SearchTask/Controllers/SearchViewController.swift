//
//  SearchViewController.swift
//  SearchTask
//
//  Created by Nesreen Mamdouh on 12/12/17.
//  Copyright © 2017 dlc. All rights reserved.
//

import UIKit
import SystemConfiguration

class SearchViewController: UIViewController,NetworkRequestCompletionHandler {
  
    @IBOutlet weak var tableView: UITableView!
    var loadingView : UIView?
    var reachability =  Reachability()!
    var networkLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.tableView.tableFooterView = UIView()
        networkLabel = displayNetworkLabel()
        addReachabilityObserver(reachability: reachability)
        self.view.addSubview(networkLabel)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataModel.sharedInstance.dataDictionary.removeAll()
        DataModel.sharedInstance.resultsNames.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func internetChanged(note: Notification) {
        let reachability = note.object as! Reachability
        if(reachability.connection != .none){
            networkLabel.removeFromSuperview()
        }else {
            self.view.addSubview(networkLabel)
        }
    }
    func onComplete(_ methodName: String) {
        tableView.reloadData()
        self.loadingView?.removeFromSuperview()
    }
    
    func onError(_ methodName: String) {
        print("Error search tab")
    }
}
extension SearchViewController : UITableViewDelegate {
    
}
extension SearchViewController : UITableViewDataSource,UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return DataModel.sharedInstance.resultsNames.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchTextFieldCell", for: indexPath) as! SearchTextFieldTableViewCell
           cell.searchTextField.backgroundColor = UIColor.init(red: 245/255, green:  245/255, blue:  245/255, alpha: 1)
            return cell


        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultTableViewCell
            let name = DataModel.sharedInstance.resultsNames[indexPath.row - 1]
            cell.nameLabel.text = name
            cell.domainLabel.text = DataModel.sharedInstance.dataDictionary[name]?[0]
            if indexPath.row % 2 != 0 {
                cell.backgroundColor = UIColor.init(red: 245/255, green:  245/255, blue:  245/255, alpha: 1)
            }
            let url =  DataModel.sharedInstance.dataDictionary[name]?[1]
            cell.logoImageView.image = UIImage()
            cell.logoImageView.startShimmering()
            NetworkRequests().getProductImage(url: url!,completionHandlerGetProductImage: {
                data in
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.logoImageView.stopShimmering()
                        cell.logoImageView.backgroundColor = UIColor.clear
                        cell.logoImageView.image = image
                        
                    }
                }
                
            })
            return cell

        }
     
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        loadingView = addLoadingView()
        self.view.addSubview(loadingView!)
        NetworkRequests().getSearchResults(query: textField.text! , sender: self)
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func addLoadingView() -> UIView{
        let view = UIView()
        view.frame = CGRect(x: 0, y: 144, width: self.view.frame.width, height: self.view.frame.height - 144)
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        view.backgroundColor = UIColor.white
        spinner.frame = CGRect(x: view.frame.width/2, y: view.frame.height/2, width: 20, height: 20)
        view.addSubview(spinner)
        return view
        
    }
    
    
}

