//
//  SubscriptionChartView.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 29.11.2025.
//


import SwiftUI
import Charts

struct SubscriptionChartView: View {
    var subscriptions: [Subscription]
    
    @State private var selectedAngleValue: Double?
    
    var selectedSubscription: Subscription? {
        guard let selectedAngleValue else { return nil }
        
        var accumulated = 0.0
        
        for sub in subscriptions {
            accumulated += sub.price
            if selectedAngleValue <= accumulated {
                return sub
            }
        }
        return nil
    }
    
    var body: some View {
        if subscriptions.isEmpty {
            ContentUnavailableView("Veri Yok", systemImage: "chart.pie")
        } else {
            ZStack {
                Chart(subscriptions) { sub in
                    SectorMark(
                        angle: .value("Fiyat", sub.price),
                        innerRadius: .ratio(0.6),
                        outerRadius: sub.id == selectedSubscription?.id ? 100 : 90,
                        angularInset: 2
                    )
                    .foregroundStyle(sub.color)
                    .cornerRadius(6)
                    .opacity(selectedSubscription == nil || selectedSubscription?.id == sub.id ? 1.0 : 0.3)
                }
                .chartAngleSelection(value: $selectedAngleValue)
                .animation(.spring(response: 0.3), value: selectedSubscription?.id)
                .frame(height: 200)
                
                VStack {
                    if let selected = selectedSubscription {
                        Text(selected.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text("₺\(String(format: "%.0f", selected.price))")
                            .font(.title2.bold())
                            .foregroundStyle(selected.color)
                            .contentTransition(.numericText())
                    } else {
                        Text("Toplam")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        let total = subscriptions.reduce(0) { $0 + $1.price }
                        Text("₺\(String(format: "%.0f", total))")
                            .font(.title2.bold())
                            .foregroundStyle(.primary)
                    }
                }
                .allowsHitTesting(false) // cursor ignoring
            }
        }
    }
}

#Preview {
    SubscriptionChartView(subscriptions: [
        Subscription(name: "Netflix", price: 200, date: Date(), iconName: "tv", color: .red),
        Subscription(name: "Spotify", price: 100, date: Date(), iconName: "music", color: .green),
        Subscription(name: "iCloud", price: 50, date: Date(), iconName: "cloud", color: .blue)
    ])
}
