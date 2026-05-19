//
//  ChaViewModel.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 25/04/26.
//


import Foundation
import SwiftUI
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    @Published var isLoading = false
    
    // 🔁 Replace with your Mac IP if testing on real iPhone
     private let baseURL = "http://localhost:11434"
    // private let baseURL = "http://192.168.1.5:11434"
    
    
    func sendMessage(_ userInput: String) async {
        
        guard !userInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        messages.append(ChatMessage(role: "user", content: userInput))
        isLoading = true
        
        guard let url = URL(string: "\(baseURL)/api/generate") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(userInput)
        let body = OllamaRequest(
           // model: "llama3:8b",
            model: "mistral",
           // model: "phi3",
           // model: "gemma:2b",
          //  prompt: userInput,
            prompt: """
            You are Lord Krishna. Answer spiritually and  Rules:
            - Always answer using a real Bhagavad Gita shloka in sanskrit
            - Explanation in hindi
            - No extra text:  \(userInput) 
            """,
            stream: false
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Debug raw response
            if let raw = String(data: data, encoding: .utf8) {
                print("RAW RESPONSE:\n", raw)
            }
            
            // Check HTTP status
            if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                let errorText = String(data: data, encoding: .utf8) ?? "Unknown error"
                messages.append(ChatMessage(role: "assistant", content: "❌ \(errorText)"))
                isLoading = false
                return
            }
            
            let decoded = try JSONDecoder().decode(OllamaResponse.self, from: data)
            
            messages.append(ChatMessage(
                role: "assistant",
                content: decoded.response
            ))
            
        } catch {
            messages.append(ChatMessage(
                role: "assistant",
                content: "❌ \(error.localizedDescription)"
            ))
            print("ERROR:", error)
        }
        
        isLoading = false
    }
}
