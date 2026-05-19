//
//  ChapterViewModel.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//


import Combine
import Foundation

final class ChapterViewModel: ObservableObject {

    @Published private(set) var chapters: [Chapter] = []

    init() {
        loadChapters()
    }

    private func loadChapters() {
        chapters = JSONLoader.load("chapters")
    }
}
