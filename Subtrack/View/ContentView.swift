//
//  ContentView.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 29.11.2025.
//

import SwiftUI
import SwiftData



struct ContentView: View {
    
    var subscriptionCount: Int = 12

    @State var sidebarEnum: Tab? = .dashboard
    @State var isShowingAddSheet: Bool = false
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Subscription.date) private var subs: [Subscription]
    
    var upcomingPayments: [Subscription] {
        subs
            .filter { $0.daysLeft <= 7 }
            .sorted { $0.daysLeft < $1.daysLeft }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $sidebarEnum) {
                Section("Yönetim") {
                    NavigationLink(value: Tab.dashboard) {
                        Label {
                            HStack {
                                Text("Genel Bakış")
                                Spacer()
                                if subs.count > 0 {
                                    Text("\(subs.count)")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Capsule().fill(.gray.opacity(0.7)))
                                }
                            }
                        } icon: {
                            Image(systemName: "chart.bar.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                    NavigationLink(value: Tab.calendar) {
                        HStack {
                            Label {
                                Text("Takvimim")
                            } icon: {
                                Image(systemName: "calendar")
                                    .foregroundStyle(.red)
                            }
                            Spacer()
                            if upcomingPayments.count > 0 {
                                Text("\(upcomingPayments.count)")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(.red))
                            }
                        }
                    }
                }
                Section("Uygulama") {
                    NavigationLink(value: Tab.settings) {
                        Label {
                            Text("Ayarlar")
                        } icon: {
                            Image(systemName: "gear")
                                .foregroundStyle(.gray)
                        }
                    }
                    /*
                    NavigationLink(value: Tab.trash) {
                        Label {
                            Text("Silinenler")
                        } icon: {
                            Image(systemName: "trash")
                                .foregroundStyle(.gray)
                        }
                    }
                     */
                }
                
            }
            .navigationSplitViewColumnWidth(min: 220, ideal: 240)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            switch sidebarEnum {
            case .dashboard:
                Overview()
            case .calendar:
                CalendarView()
            case .settings:
                SettingsView()
            case nil:
                //ContentUnavailableView("Başlamak için hazırsın", systemImage: "tray", description: Text("Aboneliklerini ekle, tekrar kontrol etmene gerek kalmasın."))
                ContentUnavailableView {
                    Label("Henüz Abonelik Yok", systemImage: "creditcard")
                        .font(.title2.bold())
                } description: {
                    Text("Aboneliklerini ekle, ödeme günlerini ve toplam giderini buradan takip et.")
                } actions: {
                    VStack(spacing: 10) {
                        Button(action: {
                            isShowingAddSheet = true
                        }) {
                            Text("İlk Aboneliğini Ekle")
                                .font(.headline)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(.glassProminent)
                        .controlSize(.large)
                        
                        Text("veya ⌘N tuşuna bas")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .padding(.top, 10)
                }
            case .trash:
                //trash ekle
                SettingsView()
            }
        }
        .sheet(isPresented: $isShowingAddSheet) {
            AddSubscriptionView()
        }
    }

    private func addItem() {
        withAnimation {
            isShowingAddSheet = true
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(subs[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Subscription.self, inMemory: true)
}
