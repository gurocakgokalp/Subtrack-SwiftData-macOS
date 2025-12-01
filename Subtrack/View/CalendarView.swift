//
//  CalendarView.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 29.11.2025.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Query private var subscriptions: [Subscription]
    @State var selectedDate: Date = Date()
    @State var currentDate = Date()
    
    let days = ["Pzt", "Sal", "Çar", "Per", "Cuma", "Cmt", "Pzr"]
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Aylık Plan")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .padding(.bottom, 10)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(1...31, id: \.self) { day in
                        DayCell(day: day, subscriptions: subscriptions)
                    }
                }
            }.navigationTitle("Takvimim")
                .padding()
        }.background(.ultraThinMaterial)
    }
}

#Preview {
    CalendarView()
}
