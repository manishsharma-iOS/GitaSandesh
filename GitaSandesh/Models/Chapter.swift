//
//  Chapter.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//

struct Chapter: Identifiable, Codable, Hashable {
    let id: Int
    let name: String          // अध्याय का नाम
    let summary: String       // अध्याय सार
    let summary_eng: String
    let totalVerses: Int
   // let chapterNumber: Int
    
    // 🎧 Chapter audio mapping
       var audioFileName: String {
           "chapter\(id)"
       }
}
