//
//  Extensions.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 29.11.2025.
//
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
        func toHex() -> String? {
        #if os(macOS)
        let uic = NSColor(self)
        #else
        let uic = UIColor(self)
        #endif
        
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

extension Date {
    
    func getAllDays() -> [Date] {
        let calendar = Calendar.current
        
        let ayBasi = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
        
        let ayKacCekiyor = calendar.range(of: .day, in: .month, for: ayBasi)!
        
        return ayKacCekiyor.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: ayBasi)!
        }
    }
    func format(_ format: String) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "tr_TR")
            return formatter.string(from: self)
        }
}

extension Subscription {
    var daysLeft: Int {
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(for: Date())
        
        let targetDay = calendar.component(.day, from: self.date)
        
        var nextPaymentComponents = calendar.dateComponents([.year, .month], from: today)
        nextPaymentComponents.day = targetDay
        
        guard let targetDateThisMonth = calendar.date(from: nextPaymentComponents) else { return 0 }
        
        if targetDateThisMonth < today {
            if let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: targetDateThisMonth) {
                let components = calendar.dateComponents([.day], from: today, to: nextMonthDate)
                return components.day ?? 0
            }
        } else {
            let components = calendar.dateComponents([.day], from: today, to: targetDateThisMonth)
            return components.day ?? 0
        }
        
        return 0
    }
    
    var daysLeftText: String {
        if daysLeft == 0 {
            return "Bugün"
        } else if daysLeft == 1 {
            return "Yarın"
        } else {
            return "\(daysLeft) gün"
        }
    }
    
    var urgentColor: Color {
        return daysLeft <= 3 ? .red : .primary
    }
}
