//
//  Shloka.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//

import Foundation

struct Shloka: Identifiable, Codable {
    let id: String
    let chapter: Int
    let verse: Int
    let sanskrit: String
    let hindiMeaning: String
    let englishMeaning: String
    
    enum MeaningLanguage: String, CaseIterable {
        case hindi = "हिंदी"
        case english = "English"
        case both = "Both"
    }
    

}
