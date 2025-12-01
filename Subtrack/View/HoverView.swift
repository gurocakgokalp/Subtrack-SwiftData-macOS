//
//  HoverView.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 30.11.2025.
//

import SwiftUI
import SwiftData

struct HoverView: View {
    var subscriptions: [Subscription]
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).fill(Color(nsColor: .controlBackgroundColor))
            VStack {
                if subscriptions.count != 0 {
                    VStack (alignment: .leading) {
                        Text("\(subscriptions.count) Abonelik")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                        ForEach(subscriptions) { sub in
                            SubscriptionCardView(sub: sub)
                        }
                    }.padding()
                } else {
                    ContentUnavailableView("Abonelik Yok", systemImage: "checkmark.circle")
                }
            }
        }.frame(width: 400)
    }
}

#Preview {
    //HoverView(day: 5)
}
