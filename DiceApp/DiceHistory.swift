//
//  DiceHistory.swift
//  DiceApp
//
//  Created by Daniel Wong on 06/07/2020.
//  Copyright © 2020 Winson. All rights reserved.
//

import Foundation
import RealmSwift

class DiceHistory: Object {
    
    @objc dynamic var dicesTotalValue: Int = 0
    @objc dynamic var firstDiceValue: Int = 0
    @objc dynamic var secondDiceValue: Int = 0
    @objc dynamic var rollingTimeDate: Date!
    
}
