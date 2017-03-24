//
//  ViewController.swift
//  TicTacToe
//
//  Created by Minh Huy Tran on 17/3/17.
//  Copyright © 2017 Minh Huy Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //outlet labels connection
    @IBOutlet weak var turnLabel: UILabel! //alert who is winner
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    //statistics label
    @IBOutlet weak var xPlayerWins: UILabel!
    @IBOutlet weak var tiesCounts: UILabel!
    @IBOutlet weak var oPlayerWins: UILabel!
    

    
    //variable
    var playerNumber = 1 //Cross player
      //game state to void replication button tag
    var gameState = [0,0,0,0,0,0,0,0,0]
    //condition game theory to win lose
    let winCondition = [[0,1,2],[0,4,8],[0,3,6],[2,4,6],[2,5,8],[6,7,8],[1,4,7],[3,4,5]]
    //=> totally 8 outcomes
    var gameActivated = true
    
    //count variables of games
    var xPlayerWinCount = 0
    var oPlayerWinCount = 0
    var tiesCount = 0
    var turnCount = 0
    
    //function to play the button
    @IBAction func ButtonPressed(_ sender: AnyObject) {
        
        if (gameState[sender.tag-1] == 0 && gameActivated == true) {
            //render the gamestate into number , here we have player number turn
            gameState[sender.tag-1] = playerNumber
        //player number 1 go first
        if (playerNumber == 1) {
            sender.setTitle("X", for: .normal)
            playerNumber = 2 //here is the turn of the 2nd player

            
        } else {
            sender.setTitle("O", for: .normal)
            playerNumber = 1
            

           
        } //loop again swap
        self.turnCount += 1
            
            
        }
        for combination in winCondition {
            
            if (gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]]) {
                
                self.gameActivated = false
                if ( gameState[combination[0]] == 1 ) {
                    //cross has won
                    print("X Player Win")
                    turnLabel.text = "X PLAYER WON!"
                    xPlayerWinCount+=1
                
            }  else {
                //O has won
                print("O Player Win")
                turnLabel.text = "O PLAYER WON!"
                oPlayerWinCount+=1
            }
                
            
            xPlayerWins.text = "X Wins: " + String(xPlayerWinCount)
            oPlayerWins.text = "O Wins:  " + String(oPlayerWinCount)
            turnLabel.isHidden = false
            playAgainButton.isHidden = false
            //out of combination x o wins
            }
            
            
                       //check ties
        }
        //check tie game and do tie counter outside the for ... in ... loop
        
        gameActivated = false
        
//check bug to make sure
        for i in gameState {
            
            if i == 0 {
                gameActivated = true
                break
                
            }
        }
        
//condition to make sure there is a tie below
        if ( turnCount == 9 && gameActivated == false)
        {
            
            tieCounter()
            turnLabel.isHidden = false
            playAgainButton.isHidden = false
            
        }
        
    }

    //extra functions for game
    
    //count tie games
    func tieCounter() {
        self.tiesCount += 1
        print("DRAW! NO ONE WIN!")
        
        //ties counr
        turnLabel.text = "DRAW!"
        tiesCounts.text = "Ties: " + String(tiesCount)
     
        
    }
    
    //play again function
    @IBAction func playAgainAction(_ sender: AnyObject) {
        gameState = [0,0,0,0,0,0,0,0,0]
        gameActivated = true
        playerNumber = 1
        turnCount = 0
        
        playAgainButton.isHidden = true
        turnLabel.isHidden = true
        
        for i in 1...9 {
            let button = view.viewWithTag(i) as! UIButton
            button.setTitle(nil, for: UIControlState())
            //this will clean all the x,o text on button, restart
        }
    }
    
    //play button start the game function here
    @IBAction func playAction(_ sender: UIButton) {
        enableButton()
        
        playButton.isHidden = true
    }
    
    
//------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        turnLabel.isHidden = true
        playAgainButton.isHidden = true
        //disable first
        disableButton()
        
        
        
    }
    //disable button - original method.
    // better way is connect all the button into 1 function with sender = anyobject.
    
    func disableButton() {
        T1.isEnabled = false
        T2.isEnabled = false
        T3.isEnabled = false
        M1.isEnabled = false
        M2.isEnabled = false
        M3.isEnabled = false
        B1.isEnabled = false
        B2.isEnabled = false
        B3.isEnabled = false
    }
    //enable
    func enableButton() {
        T1.isEnabled = true
        T2.isEnabled = true
        T3.isEnabled = true
        M1.isEnabled = true
        M2.isEnabled = true
        M3.isEnabled = true
        B1.isEnabled = true
        B2.isEnabled = true
        B3.isEnabled = true
    }
    
// button outlet
    @IBOutlet weak var T1: UIButton!
    @IBOutlet weak var T2: UIButton!
    @IBOutlet weak var T3: UIButton!
    @IBOutlet weak var M1: UIButton!
    @IBOutlet weak var M2: UIButton!
    @IBOutlet weak var M3: UIButton!
    @IBOutlet weak var B1: UIButton!
    @IBOutlet weak var B2: UIButton!
    @IBOutlet weak var B3: UIButton!
    

    
    //
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

