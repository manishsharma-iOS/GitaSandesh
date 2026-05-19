//
//  KrishnaChatViewModel.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 01/05/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class KrishnaChatViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var messages: [ChatMessageNew] = []

    @Published var inputText: String = ""

    @Published var isLoading: Bool = false

    // Used by typing animation in UI
    @Published var isTyping: Bool = false

    // Auto scroll trigger
    @Published var lastMessageID: UUID?

    // Optional error text
    @Published var errorMessage: String?

    // MARK: - Private Properties

    private let ai = KrishnaAIService()

    // MARK: - Send Message

    func sendMessage() {

        let question = inputText
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !question.isEmpty else { return }

        // Prevent multiple sends
        guard !isLoading else { return }

        // Add User Message
        let userMessage = ChatMessageNew(
            text: question,
            isUser: true
        )

        messages.append(userMessage)

        lastMessageID = userMessage.id

        // Clear Input
        inputText = ""

        // Show Loading / Typing
        isLoading = true
        isTyping = true

        // Haptic Feedback
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()

        Task {

            do {

                // Simulated natural delay
                try? await Task.sleep(
                    for: .milliseconds(700)
                )

                let answer = try await ai.askKrishna(
                    question: question
                )

                let krishnaMessage = ChatMessageNew(
                    text: answer,
                    isUser: false
                )

                messages.append(krishnaMessage)

                lastMessageID = krishnaMessage.id

                // Success Haptic
                UINotificationFeedbackGenerator()
                    .notificationOccurred(.success)

            } catch {

                errorMessage = error.localizedDescription

                let errorReply = ChatMessageNew(
                    text: """
                    Krishna is unavailable right now.
                    Please try again in a moment.
                    """,
                    isUser: false
                )

                messages.append(errorReply)

                lastMessageID = errorReply.id

                // Error Haptic
                UINotificationFeedbackGenerator()
                    .notificationOccurred(.error)

                print("Krishna AI Error:", error)
            }

            isLoading = false
            isTyping = false
        }
    }

    // MARK: - Clear Chat

    func clearChat() {

        withAnimation {

            messages.removeAll()
        }
    }

    // MARK: - Suggested Prompts

    var suggestedPrompts: [String] {

        [
            "How can I find peace?",
            "What is karma?",
            "How to control anger?",
            "Explain Bhagavad Gita simply",
            "How to stay positive?"
        ]
    }

    // MARK: - Send Suggested Prompt

    func sendSuggestedPrompt(_ prompt: String) {

        inputText = prompt
        sendMessage()
    }
}
