//
//  UpcomingRowView.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 30.11.2025.
//

import SwiftUI

struct UpcomingRowView: View {
    
    @State var isHover: Bool = false
    var sub: Subscription
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isHover == true ? .black : sub.color).opacity(0.2).blur(radius: 20)
                        .frame(width: 40, height: 40)
                        .animation(.spring(), value: isHover)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isHover == true ? .black : sub.color).opacity(0.4)
                        .frame(width: 40, height: 40)
                        .animation(.spring(), value: isHover)
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
                    .background(isHover == false ? Color(.red) : Color(.black.opacity(0.3)))
                    .cornerRadius(8)
                    .foregroundStyle(isHover == false ? .white : .red)
                    .animation(.spring(), value: isHover)
            }
            
        }.padding()
            .onHover { hovering in
                //isHover = hovering
                
            }
    }
}

#Preview {
    //UpcomingRowView()
}
