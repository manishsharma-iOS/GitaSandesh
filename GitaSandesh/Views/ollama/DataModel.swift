//
//  DataModel.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 25/04/26.
//

import Foundation
import SwiftUI
// MARK: - UI Message
struct ChatMessage: Identifiable {
    let id = UUID()
    let role: String
    let content: String
}

// MARK: - Ollama Request
struct OllamaRequest: Codable {
    let model: String
    let prompt: String
    let stream: Bool
}

// MARK: - Ollama Response
struct OllamaResponse: Codable {
    let response: String
}


import Foundation

struct ChatMessageNew: Identifiable {

    let id = UUID()

    var text: String

    let isUser: Bool
    
    let date = Date()
    
    var timeString: String {

           let formatter = DateFormatter()
           formatter.timeStyle = .short

           return formatter.string(from: date)
       }
}
