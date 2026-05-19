//
//  JSONLoader.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//
import Foundation

final class JSONLoader {

    static func load<T: Decodable>(_ filename: String) -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            fatalError("❌ \(filename).json not found in bundle")
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("❌ Failed to decode \(filename).json: \(error)")
        }
    }
}

