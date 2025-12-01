//
//  EditSubscriptionView.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 30.11.2025.
//

import SwiftUI
import SwiftData

struct EditSubscriptionView: View {
    @Environment(\.dismiss) var dismiss
        
    let sub: Subscription
    @State private var name: String = ""
    @State private var priceString: String = ""
    @State private var price: Double?
    @State private var date: Date = Date()
    @State private var selectedColor: Color = .blue
    @State private var selectedIcon: String = "creditcard.fill"
    
    let symbols = [
            "creditcard.fill", "banknote.fill", "cart.fill", "bag.fill", // Finans
            "play.tv.fill", "tv.fill", "popcorn.fill", "movieclapper.fill", // Film/Dizi
            "music.note", "music.mic", "headphones", // Müzik
            "gamecontroller.fill", "arcade.stick.console.fill", // Oyun
            "icloud.fill", "externaldrive.fill", "folder.fill", // Depolama
            "book.fill", "graduationcap.fill", // Eğitim
            "sportscourt.fill", "dumbbell.fill", // Spor
            "wifi", "phone.fill", "bolt.fill",
            "car.side.fill", "house.fill"// Faturalar
        ]
    
    let colors: [Color] = [
            .red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink, .brown, .gray, .black
        ]

    
    var body: some View {
        NavigationStack {
            Form {
                Section("\(sub.name) Bilgileri") {
                    TextField("Abonelik İsmi", text: $name)
                    TextField("Aylık Kesim Miktarı", value: $price, format: .currency(code: "TRY"))
                    DatePicker("Abonelik Kesim Tarihi", selection: $date, displayedComponents: .date)
                }
                /*
                Section("Renk Seç") {
                        ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(colors, id: \.self) { color in
                                    Circle()
                                        .fill(color)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.primary, lineWidth: selectedColor == color ? 2 : 0)
                                                .padding(-4)
                                        )
                                            .onTapGesture {
                                            withAnimation { selectedColor = color }
                                            }
                                }
                                    ColorPicker("", selection: $selectedColor)
                                        .labelsHidden()
                        }.disabled(true)
                                .padding(.vertical, 5)
                            }
                        }
                      */
                    Section("İkon Seç") {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 15) {
                                ForEach(symbols, id: \.self) { symbol in
                                    Image(systemName: symbol)
                                        .font(.title2)
                                        .frame(width: 40, height: 40)
                                    .foregroundStyle(selectedIcon == symbol ? .white : .primary)
                                    .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedIcon == symbol ? selectedColor : Color.clear)
                                    )
                                    .onTapGesture {
                                        withAnimation { selectedIcon = symbol }
                                    }
                            }
                        }
                        .padding(.vertical, 5)
                    }
            }
            .formStyle(.grouped)
            .navigationTitle("Aboneliği Düzenle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                    .keyboardShortcut(.escape)
                }
            
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        print("Kaydediliyor: \(name)")
                        saveSubscription()
                    }
                    // || kullan
                    .disabled(name.isEmpty)
                }
            }
        }.onAppear {
            name = sub.name
            price = sub.price
            date = sub.date
            selectedColor = sub.color
            selectedIcon = sub.iconName
        }
        .frame(width: 500, height: 500)
        
    }
    
    func saveSubscription() {
        sub.name = name
        sub.price = price ?? 0
        sub.date = date
        sub.iconName = selectedIcon
        //sub.hexColor = selectedColor
        
        dismiss()
        }

}

#Preview {
    //EditSubscriptionView()
}
