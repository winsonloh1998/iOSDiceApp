//
//  DiceHistoryViewController.swift
//  DiceApp
//
//  Created by Daniel Wong on 03/07/2020.
//  Copyright © 2020 Winson. All rights reserved.
//

import UIKit
import RealmSwift

class DiceHistoryTableViewCell: UITableViewCell{
    
    @IBOutlet weak var firstDiceImageView: UIImageView!
    @IBOutlet weak var secondDiceImageView: UIImageView!
    @IBOutlet weak var rollingDateTimeLabel: UILabel!
    @IBOutlet weak var diceTotalValueLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!
}

class DiceHistoryViewController: UIViewController {
    
    @IBOutlet weak var diceHistoryTableView: UITableView!
    var diceHistory: Array<Int> = Array()
    
    //Variables that will store the data retrieve from the database
    var diceHistories: Results<DiceHistory>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set round corner for table view
        diceHistoryTableView.layer.cornerRadius = 10
        
        //Set data source and callback to TableView
        diceHistoryTableView.delegate = self
        diceHistoryTableView.dataSource = self
        
        //Create an instance of Realm
        let realm = try! Realm()
       
        diceHistories = realm.objects(DiceHistory.self)
    }
}



extension DiceHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Show message when the row is selected
        print("you tapped me!")
    }
}

extension DiceHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Determine how many rows will be in Table View
        return diceHistories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create content for each row
        let row = tableView.dequeueReusableCell(withIdentifier: "DiceRolledRecords", for: indexPath) as! DiceHistoryTableViewCell
        
        //row.textLabel?.text = String(diceHistory[indexPath.row])
        
        //Change the date Format
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
        let rollingDateTimeFormatted = dateFormatter.string(from: diceHistories[indexPath.row].rollingTimeDate)
        
        //Display First Dice Image
        row.firstDiceImageView?.image = UIImage(named: "Dice\(diceHistories[indexPath.row].firstDiceValue)")
        
        //Display Second Dice Image
        row.secondDiceImageView?.image = UIImage(named: "Dice\(diceHistories[indexPath.row].secondDiceValue)")
        
        //Display rolling date and time
        row.rollingDateTimeLabel.text = rollingDateTimeFormatted

        //Display sum up dices value
        row.diceTotalValueLabel.text = "Total: " +  String(diceHistories[indexPath.row].dicesTotalValue)
        
        row.trashButton.tag = indexPath.row
        
        row.trashButton.addTarget(self, action: #selector(onTrashClicked(_:)), for: UIControl.Event.touchUpInside)
        
        return row
    }
    
    @objc func onTrashClicked(_ sender: UIButton){
        print(sender.tag)
        
        let realm = try! Realm()
        
        //Delete the selected record
        try! realm.write{
            realm.delete(diceHistories[sender.tag])
        }
    
        //Refresh the Table View
        self.diceHistoryTableView.reloadData()
    }
}
