//
//  Item.swift
//  JukeBox
//
//  Created by Maëva Bouvard on 14/06/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
