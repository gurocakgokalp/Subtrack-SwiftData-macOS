//
//  UpcomingPaymentsView.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 30.11.2025.
//

import SwiftUI

struct UpcomingPaymentsView: View {
    
    var subscriptions: [Subscription]
        
    var upcomingSubs: [Subscription] {
        subscriptions
            .filter { $0.daysLeft <= 7 }
            .sorted { $0.daysLeft < $1.daysLeft }
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            if upcomingSubs.isEmpty {
                Spacer()
                ContentUnavailableView("Yaklaşan Ödeme Yok", systemImage: "checkmark.circle", description: Text("Rahatına bak! ☕️"))
                Spacer()
            } else {
                Text("Yaklaşan Abonelikler (7 Gün)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                VStack(spacing: -10) {
                    ForEach(upcomingSubs) { sub in
                        UpcomingRowView(sub: sub)
                    }
                }
                Spacer()
            }
            
        }.padding()
            .background(Color(nsColor: .controlBackgroundColor))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
    }
}

#Preview {
    //UpcomingPaymentsView()
}
