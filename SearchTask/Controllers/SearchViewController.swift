//
//  SearchViewController.swift
//  SearchTask
//
//  Created by Nesreen Mamdouh on 12/12/17.
//  Copyright © 2017 dlc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,NetworkRequestCompletionHandler {
  
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataModel.sharedInstance.dataDictionary.removeAll()
        DataModel.sharedInstance.resultsNames.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func onComplete(_ methodName: String) {
        tableView.reloadData()
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
            NetworkRequests().getProductImage(url: url!,completionHandlerGetProductImage: {
                data in
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        
                        cell.logoImageView.image = image
                        if indexPath.row % 2 != 0 {
                            cell.logoImageView.backgroundColor = UIColor.init(red: 245/255, green:  245/255, blue:  245/255, alpha: 1)
                        }
                    }
                }
                
            })
            return cell

        }
     
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        NetworkRequests().getSearchResults(query: textField.text! , sender: self)
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
