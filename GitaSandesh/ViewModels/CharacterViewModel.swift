//
//  CharacterViewModel.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//

import Foundation
import Combine


@MainActor
final class CharacterViewModel: ObservableObject {

    @Published var characters: [MahabharataCharacter] = []

    init() {
        loadCharacters()
    }

    private func loadCharacters() {
        let decoded: [MahabharataCharacter] =
            JSONLoader.load("mahabharataCharacter")
        self.characters = decoded
    }
}
