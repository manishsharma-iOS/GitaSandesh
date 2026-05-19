//
//  MahabharataCharacterDetailView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 12/02/26.
//
import SwiftUI
struct MahabharataCharacterDetailView: View {

    let character: MahabharataCharacter

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                Image("\(character.id)")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 8)

                VStack(alignment: .leading, spacing: 12) {

                    Text(character.name)
                        .font(.largeTitle.bold())

                    Text(character.englishName)
                        .font(.title3)
                        .foregroundColor(.secondary)

                    Text(character.role)
                        .font(.headline)
                        .foregroundColor(.blue)

                    Divider()

                    Text("हिंदी विवरण")
                        .font(.headline)

                    Text(character.descriptionHindi)
                        .font(.body)

                    Divider()

                    Text("English Description")
                        .font(.headline)

                    Text(character.descriptionEnglish)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
