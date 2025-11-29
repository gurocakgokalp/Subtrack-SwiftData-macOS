//
//  Item.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 29.11.2025.
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
