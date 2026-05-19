//
//  MahabharataCharacterRowView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 12/02/26.
//
import SwiftUI

struct MahabharataCharacterRowView: View {
    
    let character: MahabharataCharacter
    
    var body: some View {
        HStack(spacing: 12) {
            
            // Image name assumed as "1", "2", "3" etc based on id
            Image("\(character.id)")
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(.white.opacity(0.6), lineWidth: 2)
                )
                .shadow(radius: 4)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(character.name)
                    .font(.headline)
                
                Text(character.englishName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(character.descriptionHindi)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
//            Image(systemName: "chevron.right")
//                .font(.caption)
//                .foregroundColor(.secondary)
        }
        .padding(.vertical, 6)
    }
}

