//
//  CharactersView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//

import SwiftUI

struct CharactersView: View {

    @StateObject private var vm = CharacterViewModel()

    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // MARK: Background Gradient
                LinearGradient(
                    colors: [
                        Color.orange.opacity(0.6),
                        Color.yellow.opacity(0.5),
                        Color.pink.opacity(0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                
                // MARK: Character List
                List {
                    
                    ForEach(vm.characters) { character in
                        
                        NavigationLink(value: character) {
                            
                            HStack(spacing: 16) {
                                
                                // Character Icon
                                ZStack {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .frame(width: 48, height: 48)
                                    
                                    Image(systemName: "person.fill")
                                        .font(.title3)
                                        .foregroundColor(.orange)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                
                                    
                                    Text(character.name)
                                        .font(.headline)
                                    Text(character.role)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            
                            // MARK: Glass Card
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(.ultraThinMaterial)
                            )
                            
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.white.opacity(0.25))
                            )
                            
                            .shadow(color: .black.opacity(0.15),
                                    radius: 8,
                                    x: 0,
                                    y: 4)
                            
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain) // removes default chevron style
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            
            .navigationTitle("गीता के पात्र")
            
            .navigationDestination(for: MahabharataCharacter.self) { character in
                MahabharataCharacterDetailView(character: character)
            }
        }
    }
}
