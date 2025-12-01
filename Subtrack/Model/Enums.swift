//
//  Enums.swift
//  Subtrack
//
//  Created by Gökalp Gürocak on 30.11.2025.
//
import SwiftUI


enum Tab: String, CaseIterable {
    case dashboard = "Genel Bakış"
    case calendar = "Takvimim"
    case settings = "Ayarlar"
    case trash = "Çöp Kutusu"
}

enum SortingEnum: String, CaseIterable {
    case eklenme = "Eklenme Zamanına Göre"
    case fiyat = "Fiyata Göre"
}

enum pieChartTimeDilim: String, CaseIterable {
    case thisMonth = "Bu Ay"
    case thisYear = "Bu Yıl"
}
