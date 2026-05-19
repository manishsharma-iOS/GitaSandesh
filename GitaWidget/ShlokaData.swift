//
//  ShlokaData.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 16/04/26.
//
import WidgetKit
import SwiftUI

struct Shloka: Codable {
    let id: String
    let chapter: Int
    let verse: Int
    let sanskrit: String
    let hindiMeaning: String
    let englishMeaning: String
}

func getTodayShloka() -> Shloka {
    
    let defaults = UserDefaults(suiteName: "group.com.manish.GitaSandesh")
    
    // 🔥 1️⃣ First priority → selected shloka
    if let data = defaults?.data(forKey: "selected_shloka"),
       let decoded = try? JSONDecoder().decode(Shloka.self, from: data) {
        
        NSLog("✅ Showing selected shloka")
        return decoded
    }
    
    // 🔁 2️⃣ Fallback → daily logic
    if let data = defaults?.data(forKey: "shloka_list"),
       let decoded = try? JSONDecoder().decode([Shloka].self, from: data),
       !decoded.isEmpty {
        
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return decoded[(day - 1) % decoded.count]
    }
    
    // ❌ Final fallback
    return fallback()
}

func fallback() -> Shloka {
    return Shloka(
        id: "0",
        chapter: 1,
        //  hindi: "",
        verse: 0,
        sanskrit: "Hello",
        hindiMeaning: "डेटा उपलब्ध नहीं.......",
        englishMeaning: "No Data"
    )
    
}
