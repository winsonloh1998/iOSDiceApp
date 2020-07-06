//
//  ViewController.swift
//  DiceApp
//
//  Created by Daniel Wong on 03/07/2020.
//  Copyright © 2020 Winson. All rights reserved.
//

import UIKit
import RealmSwift

class RollDiceViewController: UIViewController {

    @IBOutlet weak var leftDiceImageView: UIImageView!
    @IBOutlet weak var rightDiceImageView: UIImageView!
    @IBOutlet weak var rollDiceButton: UIButton!
    @IBOutlet weak var diceHistoryButton: UIButton!
    
    var timer: Timer?
    var rollDiceDuration = 5.0
    
    //Array
    var diceSumedUpValueRecord: [Int] = [] //Alternative Way => diceSumedUpValueRecord: Array<Int> = Array()
    
    @IBAction func rollDice(_ sender: UIButton) {
        //Start Timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            let firstNumber = self.generateRandomNumber()
            let secondNumber = self.generateRandomNumber()
            
            //Disable button
            self.rollDiceButton.isHidden = true
            self.diceHistoryButton.isHidden = true
        
            self.rollDiceDuration -= 0.1
            self.leftDiceImageView.image = UIImage(named: "Dice\(firstNumber)")
            self.rightDiceImageView.image = UIImage(named: "Dice\(secondNumber)")
            
            if self.rollDiceDuration <= 0.0{
                //Reset the duration
                self.rollDiceDuration = 5.0
                //Stop the timer
                self.timer?.invalidate()
                //Set timer to nil
                self.timer = nil
                //Enable button
                self.rollDiceButton.isHidden = false
                self.diceHistoryButton.isHidden = false
                //Show dialog with sum up value
                self.printSumUpMessage(firstNumber: firstNumber, secondNumber: secondNumber)
            }
        })
    }
    
    //return a random number as int
    func generateRandomNumber() -> Int{
        return (1...6).randomElement()!;
    }
    
    //display alert dialog with the sum up value
    func printSumUpMessage(firstNumber: Int, secondNumber: Int){
        let sumUpValue = (firstNumber + secondNumber)
        
        let alert = UIAlertController(title: "", message: "The sum is \(sumUpValue)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            //insert the sum up value to the array, once OK is pressed
            self.diceSumedUpValueRecord.append(sumUpValue)
            
            //Save into the Realm (database)
            //Create an instance of Realm
            let realm = try! Realm()
            
            //To find the realm file path so that it can be opened by realm studio
            print(Realm.Configuration.defaultConfiguration.fileURL)
            
            //Save dice result into DiceHistory
            let diceHistory = DiceHistory()
            diceHistory.firstDiceValue = firstNumber
            diceHistory.secondDiceValue = secondNumber
            diceHistory.dicesTotalValue = sumUpValue
            diceHistory.rollingTimeDate = Date()
            
            //Write data into database
            try! realm.write {
                realm.add(diceHistory)
            }
            
        } ))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //Pass the dice history using segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.destination is DiceHistoryViewController{
            let viewController = segue.destination as? DiceHistoryViewController
            viewController?.diceHistory = diceSumedUpValueRecord
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Making Roll Dice button to have round corner
        rollDiceButton.layer.cornerRadius = 10
        rollDiceButton.layer.borderWidth = 1
        rollDiceButton.layer.borderColor = UIColor.red.cgColor
        
        //Making Dice History Button to have round corner
        diceHistoryButton.layer.cornerRadius = 10
    }
}

