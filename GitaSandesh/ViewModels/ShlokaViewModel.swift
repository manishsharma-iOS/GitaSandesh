//
//  ShlokaViewModel.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//
import Combine
import Foundation
import SwiftUI
import WidgetKit

final class ShlokaViewModel: ObservableObject {
    
    @Published private(set) var shlokas: [Shloka] = []{
        didSet {
                     saveToWidget()
                   }
    }
    
    init() {
        loadShlokas()
        
    }
    
    
    private func loadShlokas() {
        shlokas = JSONLoader.load("shlokas")
    }
    
    func randomShloka() -> Shloka? {
        shlokas.randomElement()
    }
    
    func shlokas(for chapter: Int) -> [Shloka] {
        shlokas.filter { $0.chapter == chapter }
    }
    func search(query: String) -> [Shloka] {
        guard !query.isEmpty else { return [] }
        
        return shlokas.filter {
            $0.sanskrit.contains(query) ||
            $0.hindiMeaning.contains(query) ||
            $0.englishMeaning.lowercased().contains(query.lowercased()) ||
            "\( $0.chapter )".contains(query) ||
            "\( $0.verse )".contains(query)
        }
        
        
    }
    
//    @Published var shlokas: [Shloka] = [] {
//            didSet {
//                saveToWidget()
//            }
//        }
        
        private func saveToWidget() {
            guard !shlokas.isEmpty else { return }
            
            let defaults = UserDefaults(suiteName: "com.geu.GeetaSandBox.gita")
            
            if let encoded = try? JSONEncoder().encode(shlokas) {
                defaults?.set(encoded, forKey: "shloka_list")
                
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
}

