//
//  ViewController.swift
//  TicTacToe
//
//  Created by Minh Huy Tran on 17/3/17.
//  Copyright © 2017 Minh Huy Tran. All rights reserved.
//

import UIKit
import AVFoundation


//to inform the delegate data we make, we have to declare the DataSentDelegate method at the top here as well
class ViewController: UIViewController {
    //outlet labels connection
    @IBOutlet weak var turnLabel: UILabel! //alert who is winner
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    //statistics label
    @IBOutlet weak var xPlayerWins: UILabel!
    @IBOutlet weak var tiesCounts: UILabel!
    @IBOutlet weak var oPlayerWins: UILabel!
    
    //audio variable
    var musicPlayer: AVAudioPlayer?
    
    //menu view setting
    @IBOutlet var menuView: UIView!
    
    //simle blur effect view
    @IBOutlet weak var effectView: UIVisualEffectView!
    var effect:UIVisualEffect!
    
    @IBOutlet weak var menuButton: UIButton!
    
    //notification of mode along
    @IBOutlet weak var PlayMode: UIButton!
    @IBOutlet weak var AILabelMode: UILabel!
    
    //outlet of player 1 and player 2 name
    @IBOutlet weak var player1TextName: UILabel!
    @IBOutlet weak var player2TextName: UILabel!
    
    
    
    var p1GetName: String! = "Player 1"
    var p2GetName: String! = "Player 2"
        //also we can custome the player name similar
    
    var historyArray = [String]()
    var nGame : Int = 0 //here to list which number of game have played so far
    
    
    //variable
    var winner :String = ""
    var tieGame = false //simple boolean variable for
    
    
    //AI Variables -----
    var AIMode = false
    var AITurnOver = false
    
    var playerOneMoves = Set<Int>()
    var playerTwoMoves = Set<Int>()
    var possibleMoves = Array<Int>()
    var playerTurn = 1
    var nextMoves : Int? = nil
    
    var allSpaces : Set<Int> = [1,2,3,4,5,6,7,8,9] //those are all player's choices here
    let boardCombination = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
    
    //---------
    
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
    
    
    //function of play mode button
    
    @IBAction func Playmode(_ sender: Any) {
        if AIMode == false {
        PlayMode.setTitle("Play With Player", for:
        .normal)
        disableButton()
        AIMode = true
            AILabelMode.text = "AI Mode: On!"
        } else if AIMode == true {
            
            PlayMode.setTitle("Play With AI", for:
                .normal)
            disableButton()
            AIMode = false
            AILabelMode.text = "AI Mode: Off!"

        }
        
    }
    
    //-----
    
    
    
    //function to play the button
    @IBAction func ButtonPressed(_ sender: AnyObject) {
        
        
        if AIMode == false {
            
        //Player vs Player Mode code
        if (gameState[sender.tag-1] == 0 && gameActivated == true ) {
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
        
        
            
        //win condition checking method
        for combination in winCondition {
            
            if (gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]]) {
                
                self.gameActivated = false
                if ( gameState[combination[0]] == 1) {
                    //cross has won
                    disableButton()
                    print("X Player Win")
                    turnLabel.text = "X PLAYER WON!"
                    xPlayerWinCount+=1
                    winner = "X"
                    
                    //update history memory
                    history()
                    
                
            }  else {
                //O has won
                    disableButton()
                print("O Player Win")
                turnLabel.text = "O PLAYER WON!"
                oPlayerWinCount+=1
                    
                    winner = "O"
                    
                    //update history memory
                    history()
                    
            }
                
            
            xPlayerWins.text = "X Wins: " + String(xPlayerWinCount)
            oPlayerWins.text = "O Wins:  " + String(oPlayerWinCount)
            turnLabel.isHidden = false
            playAgainButton.isHidden = false
            //out of combination x o wins
            }
        }
        
        gameActivated = false

        for i in gameState {
            
            if i == 0 {
                gameActivated = true
                break
                
            }
            
            
        }

        
        //check tie game and do tie counter outside the for ... in ... loop
        
        
//check bug to make sure
       
        if ( turnCount == 9 && gameActivated == false && winner == "")
        {
            disableButton()
            tieCounter()
            turnLabel.isHidden = false
            playAgainButton.isHidden = false
            
            tieGame = true //detect a tie game condition
            history()
            
        }
        
        }
//condition to make sure there is a tie below
        
        //end of player vs player mode code
        
        //button play mode action
        
        
        
        //Player VS AI. Player plays as X  and AI plays as O  --------
        if AIMode == true {
            
            //check if 2 players choose same button on board
            if playerOneMoves.contains(sender.tag) || playerTwoMoves.contains(sender.tag) {
                
                print("The space have been used!")
                
            } else {
                
                if playerTurn  % 2 != 0 {    // if player turn divided by two not equal to 0 that's mean our turn again! first player
                   //add space to player move list in that data
                    
                    playerOneMoves.insert(sender.tag)
                    sender.setTitle("X", for: .normal)
                    //print( "Player 2's Turn")
                    
                    if isWinner(player: 1) == 0 {
                        
                        let nextMove =  aiDefend()
                        playerTwoMoves.insert(nextMove)
                        
                        let button = self.view.viewWithTag(nextMove) as? UIButton // we get button tag by every next move
                        
                        button?.setTitle("O", for: .normal)
                        
                       // print("Player 1's Turn")
                        
                        
                        isWinner(player: 2) //avoid duplicate value of 1.
                        
                    }
                    //end of iswinner if list
                    
                }
                
                playerTurn += 1
                
                if playerTurn > 9 && isWinner(player: 1) < 1 {
                    turnLabel.text = "DRAW!"
                    turnLabel.isHidden = false
                    playAgainButton.isHidden = false
                    
                    //get score for draws
                    tiesCount = tiesCount + 1
                    tiesCounts.text = "Ties: \(tiesCount)"
                    
                    tieGame = true
                    //update history memory
                    history()
                    
                    for index in 1...9 {
                        let button = self.view.viewWithTag(index) as! UIButton
                        button.isEnabled = false
                        
                        
                    }
                    
                }
                
            }
            
            
            
            
            
           //ai mode end ---
        }
        
        
        
        
        // End of player vs AI mode code ---------
        
        
        
    }

    //extra functions for game
    
    //menu button action
    
    @IBAction func menuAction(_ sender: UIButton) {
        
animateIN()
    }
    
    func animateIN() {
        effectView.isHidden = false
        self.view.addSubview(menuView)
        menuView.center = self.view.center
        //center the view automatically
        menuView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        menuView.alpha = 0
        
        //animate the effect
        UIView.animate(withDuration: 0.5) { 
            self.effectView.effect = self.effect
            self.menuView.alpha = 1
            self.menuView.transform = CGAffineTransform.identity
        }
        
        
    }
    
    func animateOUT() {
        effectView.isHidden = true
        
        UIView.animate(withDuration: 0.5, animations: {
        self.menuView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.menuView.alpha = 0
            self.effectView.effect = nil
        } ) {(success: Bool) in
self.menuView.removeFromSuperview()
            
        }
    }
    
    @IBAction func closeSetting(_ sender: Any) {
        
        animateOUT()
        //we can add uiview effect animation but this one i want to keep it simple for testing easily
        
        
    }
    //player name action button in setting view
    @IBAction func playerNameButton(_ sender: Any) {
        musicPlayer?.stop()
    }
    
    
    
    //---- setting function done
    
    //AI function
    
    
    
    func isWinner(player: Int) -> Int {
        
        var winner = 0
        var moveList = Set<Int>()
        
        if player == 1 {
            
            moveList = playerOneMoves
            
        } else {
            
            moveList = playerTwoMoves
        }
        
        //check the game condition if there is a winning combination or not

        for combo in boardCombination {
            if moveList.contains(combo[0]) && moveList.contains(combo[1]) && moveList.contains(combo[2]) && moveList.count > 2 {
                
                winner = player
                turnLabel.text = "Player \(player) has won!"
                turnLabel.isHidden = false
                playAgainButton.isHidden = false
                
                //add score for X and O
                if winner == 1 {
                    xPlayerWinCount = xPlayerWinCount + 1
                    
                    //update history memory
                    history()
                    
                } else if winner == 2 {
                    oPlayerWinCount = oPlayerWinCount + 1
                    
                    //update history memory
                    
                    history()
                    
                }
                xPlayerWins.text = "X Wins: \(xPlayerWinCount)"
                oPlayerWins.text = "O Wins: \(oPlayerWinCount)"
                //-----
                for index in 1...9 {
                    
                    let tile = self.view.viewWithTag(index) as! UIButton
                    tile.isEnabled = false
                    
                    //this will tempority disable button to avoid unexpected misclick for wrong solution. it will active again until the play agian button used.
                }
                
            }
        }
        
       
        
        
        return winner
    }
    //--- 1 this the function calculated possible spaces on board that AI can play upon player
    
    func aiDefend() -> Int {
        
        var possibleLosses = Array<Array<Int>>()  //two variables here base on for combo in... and for play in combo..
        var possibleWines = Array<Array<Int>>()
        
        let spaceLeft = allSpaces.subtracting(playerOneMoves.union(playerTwoMoves))
        
        //go through each combination to see how many possibilities can be make for AI.
        
        for combo in boardCombination {
            
            var count = 0
            
            
            //check each player of the combintaion
            for play in combo {
                
                if playerOneMoves.contains(play) {
                    count += 1
                    
                }
                
                if playerTwoMoves.contains(play) {
                    
                    count -= 1
                }
                
                if count == 2 {
                    possibleLosses.append(combo)
                    count = 0
                    
                }
                
                if count == -2 {
                    possibleWines.append(combo)
                    count = 0
                    
                }
                
                
                
                //end of play in combo
            }
            
            
            //end of combo in win condition
        }
        
        if possibleWines.count > 0 {
            
            
            for combo in boardCombination {
                
                for space in combo {
                    
                    if !(playerOneMoves.contains(space) || playerTwoMoves.contains(space)) {
                        
                        return space
                    
                }
            }
            
        }

        
    }
//end of the if
        
        
        
        if possibleLosses.count > 0 {
            
            for combo in boardCombination {
                
                for space in combo {
                    if !(playerOneMoves.contains(space) || playerTwoMoves.contains(space)) {
                        
                        possibleMoves.append(space)
                        
                    }
                }
            }
        }
    //end of the if
        if possibleMoves.count > 0 {
            nextMoves = possibleMoves[Int(arc4random_uniform(UInt32(possibleMoves.count)))]
            
        }
            //to know which button choicse from 1 - 8 has been use, subtract it
        else if allSpaces.subtracting(playerOneMoves.union(playerTwoMoves)).count > 0 {
            //figure which choise in board space has been used and havent's in that case we got new situation
            //as collections move their indices, you'd want use the collection's index(_:offsetBy:) method instead
            
            nextMoves =  spaceLeft[spaceLeft.index(spaceLeft.startIndex, offsetBy: Int(arc4random_uniform(UInt32(spaceLeft.count))))]
            
            
        }
        

        possibleMoves.removeAll()
        possibleLosses.removeAll()
        possibleWines.removeAll()
        //reset all the posibilities again to develop new one
        
        playerTurn += 1
        return nextMoves!
        //end if
        
    }
    
    ///-----
    
    
    
    
    //count tie games
    func tieCounter() {
        tiesCount += 1
        print("DRAW! NO ONE WIN!")
        
        //ties counr
        turnLabel.text = "DRAW!"
        tiesCounts.text = "Ties: " + String(tiesCount)
     
        
    }
    
    //new game for AI Mode
    func newGame() {
        
        winner = ""
        tieGame = false
        
        playerOneMoves.removeAll()
        playerTwoMoves.removeAll()
        playerTurn = 1
        //reset all the int variable of two player so far
        
        //setup tiles of the board
        for index in 1...9 {
            let tile = self.view.viewWithTag(index) as! UIButton
            tile.isEnabled = true
            tile.setTitle("", for: .normal)
            
        }
        
        
    }
    
    
    
    //play again function
    @IBAction func playAgainAction(_ sender: AnyObject) {
        
        if AIMode == true {
            
            newGame()
            turnLabel.isHidden = true
            
        } else if AIMode == false {
        //original code for player vs player
        //reset the game
        winner = ""
        tieGame = false
            
            
        enableButton()
        
        gameState = [0,0,0,0,0,0,0,0,0]
        gameActivated = true
        playerNumber = 1
        turnCount = 0
        
        playAgainButton.isHidden = false
        turnLabel.isHidden = true
        
        for i in 1...9 {
            let button = view.viewWithTag(i) as! UIButton
            button.setTitle(nil, for: UIControlState())
            //this will clean all the x,o text on button, restart
        }
        
    }
        
    }
    
    //play button start the game function here
    @IBAction func playAction(_ sender: UIButton) {
        enableButton()
        playButton.isHidden = true
        playAgainButton.isHidden = false
        playAgainButton.setTitle("New Game", for: .normal)
    }
    
    
    //music function
    
    func backgroundMusic() {
        let path = Bundle.main.path(forResource: "chopin", ofType: "mp3") //url of the file
        let url = URL(fileURLWithPath: path!)
        
        do {
            //set up the player by loading the sound file
            try musicPlayer = AVAudioPlayer(contentsOf: url)
        }
        //catch the error if playback fails
        
        catch {
            print("file not available!")
        }
        
        
        //play music
        if musicPlayer != nil {
            musicPlayer?.play()
            musicPlayer?.numberOfLoops = 1
        }
        
    }
 //History function for both AI and PvP mode
    
    
    @IBAction func historyActionButton(_ sender: UIButton) {
        //segue name: historySegue
        //base on identifier to send the correct one
        self.performSegue(withIdentifier: "historySegue", sender: self)
        
        
    }
    
    
    //extra function prepare for passing data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //stop the music then
        musicPlayer?.stop()
        //send name player 1 protocol
        if segue.identifier == "historySegue" {
          
            
            if let destination = segue.destination as? HistoryVC {
                
                destination.HistoryArray = historyArray
                
            }
        }
        //send name player 2 protocol
        
        
        
        
    }

    
    //action button Game History
    
    func history() {
        nGame = nGame + 1
        
        if winner == "X" || winner == "1" {
            
            historyArray.append("Game \(nGame) :\(p1GetName!) won \(p2GetName!)")
            
        } else if winner == "O" || winner == "2" {
            historyArray.append("Game \(nGame) :\(p2GetName!) won \(p1GetName!)")

            
        } else if tieGame == true {
            historyArray.append("Game \(nGame) : It was a tie - draws game")

        }
        
        
    }
    
    
    //history public function
    
   
    
    
//------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        turnLabel.isHidden = true
        playAgainButton.isHidden = true
        //disable first
        disableButton()
        
        //music background
        backgroundMusic()
        
        //disable effect firstly
        effectView.isHidden = true
        effect = effectView.effect
        effectView.effect = nil
        menuButton.layer.cornerRadius = 5
        menuView.layer.cornerRadius = 5
        
        
       //get name straigh from changer
        player1TextName.text = p1GetName
        player2TextName.text = p2GetName
        if p1GetName == "" {
            player1TextName.text = "Player 1"
            
        }
        if p2GetName == "" {
            player2TextName.text = "Player 2"
        }
        
        AILabelMode.text = "AI Mode: Off..."

        
    }
    //disable button - original method.
    // better way is connect all the button into 1 function with sender = anyobject.
    
    func disableButton() {
      
        for button in buttonsGame {
            button.isEnabled = false
        }
    }
    //enable
    func enableButton() {
       
        for button in buttonsGame {
            button.isEnabled = true
        }
    }
    
// button outlet collection
    @IBOutlet var buttonsGame: [UIButton]!
    
    
    
    //
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //user default func neccessary
  

}

