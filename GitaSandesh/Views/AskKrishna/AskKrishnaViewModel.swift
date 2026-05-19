//
//  AskKrishnaViewModel.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/04/26.
//
import SwiftUI
import Combine

@MainActor
class AskKrishnaViewModel: ObservableObject {
    
    @Published var responses: [KrishnaResponse] = []
    @Published var isLoading = false
    
    private let service = OpenAIService()
    
    func ask(question: String) async {
        guard !question.isEmpty else { return }
        
        isLoading = true
        
        do {
            let result = try await service.askKrishna(question: question)
            responses.append(result)
            print(question)
        } catch {
            print("Error:", error)
        }
        
        isLoading = false
    }
}
