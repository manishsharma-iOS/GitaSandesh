//
//  BookmarkManager.swift
//  GeetaSandBox
//  Created by Manish Sharma on 30/01/26.
//
import Foundation
import SwiftUI
import Combine
class BookmarkManager: ObservableObject {
    
    @Published var bookmarks: [Bookmark] = []
    
    private let key = "bookmarked_shlokas"

    init() {
        load()
    }

    // MARK: - Add
    func add(_ bookmark: Bookmark) {
        if !bookmarks.contains(bookmark) {
            bookmarks.append(bookmark)
            save()
        }
    }

    // MARK: - Remove
    func remove(_ bookmark: Bookmark) {
        bookmarks.removeAll { $0.id == bookmark.id }
        save()
    }

    // MARK: - Check
    func isBookmarked(id: String) -> Bool {
        bookmarks.contains { $0.id == id }
    }

    // MARK: - Save
    private func save() {
        if let data = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    // MARK: - Load
    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Bookmark].self, from: data) {
            bookmarks = decoded
        }
    }
}
