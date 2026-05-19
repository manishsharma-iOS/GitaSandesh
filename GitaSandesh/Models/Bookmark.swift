//
//  Bookmark.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 30/01/26.
//

import Foundation

struct Bookmark: Identifiable, Codable, Equatable {
    let id: String          // unique key
    let chapter: Int
    let verse: Int
    let shloka: String
    let hindiMeaning: String
    let englishMeaning: String
}
