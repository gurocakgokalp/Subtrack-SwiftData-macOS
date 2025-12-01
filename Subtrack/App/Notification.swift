//
//  Notification.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 30.11.2025.
//
import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("İzin verildi!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotification(for sub: Subscription, dayBefore: Int) {
        let content = UNMutableNotificationContent()
        content.title = "\(sub.name) Ödemesi Yaklaşıyor"
        content.subtitle = "\(sub.price) TL tutarındaki ödemen için son \(sub.daysLeft) gün."
        content.sound = .default
        
        var dateComponents = DateComponents()
        let calendar = Calendar.current
        let paymentDay = calendar.component(.day, from: sub.date)
        
        let today = Date()
        var components = calendar.dateComponents([.year, .month], from: today)
        components.day = paymentDay
        
        if let paymentDate = calendar.date(from: components),
            let triggerDate = calendar.date(byAdding: .day, value: -dayBefore, to: paymentDate) {
            
            let triggerDay = calendar.component(.day, from: triggerDate)
            dateComponents.day = triggerDay

            dateComponents.hour = 10
            dateComponents.minute = 0
                    
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
            let request = UNNotificationRequest(identifier: sub.id.uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request)
            print("bildirim kuruldu: \(sub.name) icin her ayin \(triggerDay). gunu")
        }
    }
    
    func removeNotification(for sub: Subscription) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [sub.id.uuidString])
            print("bildirim silindi: \(sub.name)")
        }
        
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("tum bildirimler temizlendi.")
    }
    
}
