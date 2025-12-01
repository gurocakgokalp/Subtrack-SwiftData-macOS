//
//  Overview.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 29.11.2025.
//

import SwiftUI
import _SwiftData_SwiftUI
import Charts

struct Overview: View {
    @Query(sort: \Subscription.price, order: .reverse) private var subscriptions: [Subscription]
    @Query(sort: \Subscription.creatingDate, order: .reverse) private var subscriptionsDate: [Subscription]
    
    @Environment(\.modelContext) private var context
    let columns = [
        GridItem(.adaptive(minimum: 250, maximum: 300), spacing: 20)
    ]
    
    var totalCost: Double {
        subscriptions.reduce(0) { $0 + $1.price }
    }
    @State var currentSub: Subscription?
    @State var isShowingEditSheet: Bool = false
    
    @State private var selectedAngleValue: Double?
    @State var isPresented: Bool = false
    @State private var selectedSorting: SortingEnum = .fiyat
    @State private var selectedPieZaman: pieChartTimeDilim = .thisMonth

    var selectedSubscription: Subscription? {
        guard let selectedAngleValue else { return nil }
        

        var accumulated = 0.0
        
        //aci hesabi
        for sub in subscriptions {
            accumulated += sub.price
            if selectedAngleValue <= accumulated {
                return sub
            }
        }
        return nil
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        HStack {
                            VStack(alignment: .leading) {
                                if !subscriptions.isEmpty {
                                    Text("Toplam Gider (Aylık)")
                                        .font(.headline)
                                        .foregroundStyle(.secondary)
                                    Text("₺\(String(format: "%.2f", totalCost))")
                                        .font(.system(size: 34, weight: .bold, design: .rounded))
                                        .foregroundStyle(.primary)
                                    Spacer(minLength: 10)
                                }else {
                                    Spacer(minLength: 10)
                                    ContentUnavailableView("Veri Yok", systemImage: "chart.pie")
                                    Spacer(minLength: 10)
                                }
                                
                                
                                /*
                                HStack {
                                    Image(systemName: "arrow.up.right.circle").bold().font(.system(size: 13)).foregroundStyle(.green.opacity(1))
                                    Text("Geçen aya göre %20")
                                        .font(.headline)
                                        .foregroundStyle(.secondary)
                                }
                                 */
                            }
                        }
                        .padding()
                        .background(Color(nsColor: .controlBackgroundColor))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                        )
                        UpcomingPaymentsView(subscriptions: subscriptions)
                        VStack(alignment: .center) {
                            HStack {
                                if !subscriptions.isEmpty {
                                    Text("Analiz")
                                        .font(.headline)
                                        .foregroundStyle(.secondary)
                                }
                                /*
                                Spacer()
                                Picker("", selection: $selectedPieZaman) {
                                    ForEach(pieChartTimeDilim.allCases, id: \.self) { time in
                                        Text(time.rawValue)
                                    }
                                }.pickerStyle(.menu)
                                */
                            }
                            Spacer()
                            SubscriptionChartView(subscriptions: subscriptions)
                            Spacer()
                        }
                            .padding()
                            .background(Color(nsColor: .controlBackgroundColor))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                            )
                        
                    }
                    
                    //
                    //
                    //
                    
                    Divider()
                    
                    HStack {
                        Text("Tüm Aboneliklerim (\(subscriptions.count))")
                            .font(.title2.bold())
                        Spacer()
                        Picker("", selection: $selectedSorting) {
                            ForEach(SortingEnum.allCases, id: \.self) { sorting in
                                Text(sorting.rawValue)
                            }
                        }.pickerStyle(.segmented)
                    }
                    
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        if selectedSorting == .fiyat {
                            ForEach(subscriptions) { sub in
                                SubscriptionCardView(sub: sub)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                context.delete(sub)
                                                NotificationManager.shared.removeNotification(for: sub)
                                            }
                                        } label: {
                                            Label("Aboneliği Sil", systemImage: "trash")
                                        }
                                        
                                        Button {
                                            currentSub = sub
                                            //isShowingEditSheet = true
                                        } label: {
                                            Label("Düzenle", systemImage: "pencil")
                                        }
                                    }
                            }
                        } else {
                            ForEach(subscriptionsDate) { sub in
                                SubscriptionCardView(sub: sub)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                context.delete(sub)
                                            }
                                        } label: {
                                            Label("Aboneliği Sil", systemImage: "trash")
                                        }
                                        
                                        Button {
                                            currentSub = sub
                                            //isShowingEditSheet = true
                                        } label: {
                                            Label("Düzenle", systemImage: "pencil")
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding()
            }.sheet(item: $currentSub) { sub in
                EditSubscriptionView(sub: sub)
            }
            .navigationTitle("Genel Bakış")
        }.background(.ultraThinMaterial)
    }
}

#Preview {
    //Overview()
}
