//
//  HistoryVC.swift
//  TicTacToe
//
//  Created by Minh Huy Tran on 3/4/17.
//  Copyright © 2017 Minh Huy Tran. All rights reserved.
//

import Foundation
import UIKit

class HistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //code start from here---------
    
    var HistoryArray = [""]
    
    //set up table view:
    
    //number of row in table list
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HistoryArray.count //count will collect number of row base on array
        
    }
    
    //cell for row at index path
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //define the identity text "cell"
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        //show the text in array <=> history
        cell.textLabel?.text = HistoryArray[indexPath.row]
        
        return cell
        
    }
    
    
    
    
    /// likely as main view controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
