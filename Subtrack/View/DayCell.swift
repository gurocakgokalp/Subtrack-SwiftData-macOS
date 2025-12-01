//
//  DayCell.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 30.11.2025.
//

import SwiftUI
import SwiftData

struct DayCell: View {
    var day: Int
    var subscriptions: [Subscription]
    let today = Calendar.current.component(.day, from: Date())
    @State var isHover: Bool = false
    @State var isPresented: Bool = false
    
    var subForToday: [Subscription] {
        subscriptions.filter { sub in
            let subDay = Calendar.current.component(.day, from: sub.date)
            return subDay == day
        }
    }
    
    
    
    var body: some View {
            VStack(alignment: .leading) {
                Text("\(day)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Spacer()
                if !subForToday.isEmpty {
                    HStack(spacing: -5) {
                        if subForToday.count > 4 {
                            ForEach(subForToday.prefix(3)) { sub in
                                ZStack {
                                    Circle()
                                        .fill(sub.color)
                                        .frame(width: 28, height: 28)
                                        .shadow(radius: 2)
                                    
                                    Image(systemName: sub.iconName)
                                        .font(.caption2)
                                        .foregroundStyle(.white)
                                }
                                //
                                .help("\(sub.name) - ₺\(sub.price)")
                            }
                            ZStack {
                                Circle()
                                    .fill(.gray)
                                    .frame(width: 28, height: 28)
                                    .shadow(radius: 2)
                                
                                Text("+\(subForToday.count - 3)")
                                    .font(.caption2)
                                    .foregroundStyle(.white)
                            }
                        } else {
                            ForEach(subForToday) { sub in
                                ZStack {
                                    Circle()
                                        .fill(sub.color)
                                        .frame(width: 28, height: 28)
                                        .shadow(radius: 2)
                                    
                                    Image(systemName: sub.iconName)
                                        .font(.caption2)
                                        .foregroundStyle(.white)
                                }
                                //
                                .help("\(sub.name) - ₺\(sub.price)")
                            }
                        }
                        
                    }
                } else {
                    Color.clear.frame(height: 28)
                }
            }
            .padding(10)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(nsColor: .controlBackgroundColor))
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                //subForToday.isEmpty
                    .stroke(isHover ? Color.white.opacity(0.5) : Color.clear, lineWidth: 1)
                    .stroke(day == today ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 2)
                    .animation(.snappy(), value: isHover)
            ).onHover { hover in
                isHover = hover
                if isHover {
                    NSCursor.pointingHand.push()
                    
                } else {
                    NSCursor.pop()
                }
            }
            .onTapGesture {
                isPresented = true
            }
            .popover(isPresented: $isPresented, arrowEdge: .trailing) {
                HoverView(subscriptions: subForToday)
            }
            
        }
}

#Preview {
    //DayCell(day: Int, subscriptions: [Subscription])
}
