//
//  NameChanger.swift
//  TicTacToe
//
//  Created by Minh Huy Tran on 2/4/17.
//  Copyright © 2017 Minh Huy Tran. All rights reserved.
//

import Foundation
import UIKit



//protocol to set up our data passing delegate method

class NameChanger: UIViewController {
    
    
    @IBOutlet weak var player1Text: UITextField!
    @IBOutlet weak var player2Text: UITextField!
    
    
    
    //player variable label outlet
//seque : sendName
    
    //action button
    @IBAction func SetButton(_ sender: Any) {
        
        //base on identifier to send the correct one
        self.performSegue(withIdentifier: "sendName", sender: self)
        //check if our text name filled .  if not then we will set it automatically then
       
    
    }
    
 
    
   //extra function prepare for passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //send name player 1 protocol
        if segue.identifier == "sendName" {
            //check name
            if player1Text.text == ""  {
                player1Text.text = "Player 1"
            }
            
            if player2Text.text == "" && player1Text.text != nil {
                player2Text.text = "Player 2"
                
            }
            
            if let destination = segue.destination as? ViewController {
                
            destination.p1GetName = player1Text.text
            destination.p2GetName = player2Text.text
                
            }
        }
        //send name player 2 protocol
        
       
        
        
    }
    
    //prepare for segue
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
   
}
