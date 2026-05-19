//
//  OpenAIService.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/04/26.
//
import Foundation

final class OpenAIService {
    
    private let apiKey = "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" // 🔐 NEVER hardcode in production
    
    func askKrishna(question: String) async throws -> KrishnaResponse {
        
        let url = URL(string: "https://api.openai.com/v1/responses")!
        
        let body: [String: Any] = [
            "model": "gpt-4.1",
            
            "input": [
                [
                    "role": "system",
                    "content": """
                    You are Lord Krishna, the divine guide from the Bhagavad Gita.

                    Rules:
                    - Always answer using a real Bhagavad Gita shloka
                    - Always return valid JSON only
                    - No extra text
                    """
                ],
                [
                    "role": "user",
                    "content": question
                ]
            ],
            
            "text": [
                "format": [
                    "type": "json_schema",
                    "name": "krishna_response",
                    "schema": [
                        "type": "object",
                        
                        // 🔥 ADD THIS LINE
                        "additionalProperties": false,
                        
                        "properties": [
                            "shloka": ["type": "string"],
                            "meaning": ["type": "string"],
                            "explanation": ["type": "string"],
                            "takeaway": ["type": "string"]
                        ],
                        "required": ["shloka", "meaning", "explanation", "takeaway"]
                    ]
                ]
            ],
            
            "temperature": 0.7
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // ✅ Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorResponse = try? JSONDecoder().decode(OpenAIErrorResponse.self, from: data)
            let message = errorResponse?.error.message ?? "Unknown API error"
            throw NSError(domain: "", code: httpResponse.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: message])
        }
        
        // DEBUG
        print("RAW:", String(data: data, encoding: .utf8) ?? "")
        
        // ✅ Decode OpenAI response
        let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        // ✅ Extract all text safely
        let allText = decoded.output
            .flatMap { $0.content }
            .compactMap { $0.text }
            .joined()
        
        guard let jsonData = allText.data(using: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        // ✅ Decode final structured response
        do {
            return try JSONDecoder().decode(KrishnaResponse.self, from: jsonData)
        } catch {
            print("⚠️ JSON decode failed:", error)
            
            // 🔁 Fallback (never crash UI)
            return KrishnaResponse(
                shloka: "—",
                meaning: "Unable to fetch structured response",
                explanation: allText,
                takeaway: "Please try again"
            )
        }
    }
}
