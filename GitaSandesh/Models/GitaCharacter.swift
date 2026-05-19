//
//  GitaCharacter.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//

import Foundation

import Foundation

struct GitaCharacter: Identifiable, Codable {

    let id: UUID = UUID()
    let name: String
    let description: String
    let imageName: String

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case imageName
    }
}

