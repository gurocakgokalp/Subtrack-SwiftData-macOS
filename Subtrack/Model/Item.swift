//
//  Item.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 29.11.2025.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Subscription: Identifiable {
    var id: UUID
    var name: String
    var price: Double
    var date: Date
    var creatingDate: Date
    var iconName: String
    var hexColor: String
    
    init(name: String, price: Double, date: Date, iconName: String, color: Color) {
        self.id = UUID()
        self.name = name
        self.price = price
        self.date = date
        self.creatingDate = Date()
        self.iconName = iconName
        self.hexColor = color.toHex() ?? "#000000" // Color'dan Hex'e çevirip kaydediyoruz
    }
    
    @Transient //db yazma only ui için diyoruz
    var color: Color {
        return Color(hex: hexColor)
    }
}
