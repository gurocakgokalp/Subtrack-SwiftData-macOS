//
//  SubscriptionCardView.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 29.11.2025.
//

import SwiftUI

struct SubscriptionCardView: View {
    var sub: Subscription
    @State private var isHover: Bool = false
    
    init(sub: Subscription) {
        self.sub = sub
    }
    var body: some View {

        //var daysLeft: Int = 5
        
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black).opacity(0.8).blur(radius: 20)
                        .frame(width: 40, height: 40)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black).opacity(0.4)
                        .frame(width: 40, height: 40)
                    Image(systemName: sub.iconName)
                        .font(.system(size: 20))
                }
                VStack(alignment: .leading) {
                    Text(sub.name)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .shadow(radius: 10)
                        .lineLimit(1)
                    Text("₺\(String(format: "%.2f", sub.price))")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.6))
                }
                Spacer()
                
                Text("\(sub.daysLeftText)")
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial.opacity(0.8))
                    .cornerRadius(8)
                    .foregroundStyle(sub.daysLeft <= 3 ? .red : .primary)
            }
            
        }.padding()
        .background(
            ZStack {
                sub.color
                LinearGradient(colors: [.black.opacity(0.4), .black.opacity(0.0)], startPoint: .topTrailing, endPoint: .bottomLeading)
                Image(systemName: sub.iconName).resizable().aspectRatio(contentMode: .fill).frame(width: 50).opacity(0.2).offset(x: 135, y: 15)
            }
            
        )
        
        .cornerRadius(20)
        .shadow(color: sub.color.opacity(0.1), radius: 10, x: 0, y: 5)
        
        .onHover { hovering in
            isHover = hovering
            
        }.overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isHover == true ? .white : .white.opacity(0), lineWidth: 2)
                .animation(.spring(), value: isHover)
        )
        /*
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
         */
    }
}

#Preview {
    SubscriptionCardView(sub: Subscription(name: "Wifi Bill", price: 200, date: Date(), iconName: "cloud.fill", color: Color(.red))).frame(width: 300)
}
