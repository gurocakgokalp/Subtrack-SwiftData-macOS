//
//  SettingsView.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 29.11.2025.
//

import SwiftUI
import UserNotifications
import SwiftData

struct SettingsView: View {
    @AppStorage("isNotificationsEnabled") private var isNotificationsEnabled = false
    @AppStorage("notificationTime") private var notificationKacGunOnce: Int = 1
    
    @Query private var subscriptions: [Subscription]
    @Environment(\.modelContext) private var context
    
    @State var alertPresented: Bool = false
    var body: some View {
        ScrollView {
            Form {
                Section("Bildirimler") {
                    Toggle("Ödeme Hatırlatıcıları", isOn: $isNotificationsEnabled)
                        .onChange(of: isNotificationsEnabled) { oldValue, newValue in
                            if newValue {
                                NotificationManager.shared.requestNotificationPermission()
                                rescheduleAll()
                            } else {
                                NotificationManager.shared.removeAllNotifications()
                            }
                        }
                    
                    if isNotificationsEnabled {
                        Picker("Ne zaman haber verilsin?", selection: $notificationKacGunOnce) {
                            Text("Ödeme Günü").tag(0)
                            Text("1 Gün Önce").tag(1)
                            Text("3 Gün Önce").tag(3)
                            Text("1 Hafta Önce").tag(7)
                        }.onChange(of: notificationKacGunOnce) { _, _ in
                            if isNotificationsEnabled {
                                rescheduleAll()
                            }
                        }
                    }
                }
                Section("Veri ve Depolama") {
                    LabeledContent("Toplam Abonelik", value: "\(subscriptions.count)")
                    Button(role: .destructive) {
                        alertPresented = true
                            } label: {
                        Text("Tüm Verileri Sil")
                            .foregroundStyle(.red)
                            }.buttonStyle(.glass)
                }
                Section("Hakkında") {
                    HStack {
                        Image(systemName: "curlybraces.square.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.blue)
                                        
                        VStack(alignment: .leading) {
                            Text("Subtrack")
                                .font(.headline)
                            Text("v1.0.0")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                                        
                            Spacer()
                            
                        VStack(alignment: .trailing) {
                            Link("GitHub", destination: URL(string: "https://github.com/gurocakgokalp")!)
                                .buttonStyle(.link)
                            Link("Linkedin", destination: URL(string: "https://github.com/gurocakgokalp")!)
                                .buttonStyle(.link)
                        }
                    }
                    .padding(.vertical, 5)
                                    
                    Text("Designed & Developed by Gökalp Gürocak")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top)
                }
            }.navigationTitle("Ayarlar")
                .formStyle(.grouped)
                //.padding()
                .alert("Tüm Veriler Silinecek", isPresented: $alertPresented) {
                    Button("İptal", role: .cancel) { }
                    Button("Sil", role: .destructive) {
                        deleteAll()
                    }
            } message: {
                Text("Bu işlem geri alınamaz. Emin misin?")
            }
        
        }.background(.ultraThinMaterial)
    }
    
    func deleteAll() {
        do {
            try context.delete(model: Subscription.self)
            NotificationManager.shared.removeAllNotifications()
            print("Veritabanı temizlendi.")
        } catch {
            print("Silme hatası: \(error)")
        }
    }
    func rescheduleAll() {
        NotificationManager.shared.removeAllNotifications()
        //mevcut sublar icin reschedule
        for sub in subscriptions {
            NotificationManager.shared.scheduleNotification(for: sub, dayBefore: notificationKacGunOnce)
        }
    }
}

#Preview {
    //SettingsView()
}
