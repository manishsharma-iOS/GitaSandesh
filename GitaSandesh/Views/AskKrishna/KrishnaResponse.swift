//
//  KrishnaResponse.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/04/26.
//
import Foundation
struct OpenAIResponse: Codable {
    let output: [Output]
}

struct Output: Codable {
    let content: [Content]
}

struct Content: Codable {
    let text: String?
}

struct OpenAIErrorResponse: Codable {
    let error: OpenAIError
}

struct OpenAIError: Codable {
    let message: String
}

struct KrishnaResponse: Codable, Identifiable {
    let id = UUID()
    let shloka: String
    let meaning: String
    let explanation: String
    let takeaway: String
}
