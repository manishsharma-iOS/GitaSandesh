//
//  KrishnaCard.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/04/26.
//
import SwiftUI

struct KrishnaCard: View {
    let response: KrishnaResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Sanskrit
            Text(response.shloka)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)
            
            Divider()
            
            // Meaning
            Text(response.meaning)
                .font(.body)
            
            // Explanation
            Text(response.explanation)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Takeaway
            Text("✨ \(response.takeaway)")
                .font(.footnote)
                .bold()
                .foregroundColor(.orange)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}
