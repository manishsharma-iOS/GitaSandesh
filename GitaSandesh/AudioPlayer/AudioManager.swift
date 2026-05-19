//
//  AudioManager.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 19/05/26.
//
import Foundation
import AVFoundation
import Combine
@MainActor
class AudioManager: ObservableObject {
    // Shared instance if you want to access it globally
    static let shared = AudioManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    // Published properties so your SwiftUI views update automatically
    @Published var currentlyPlayingChapterID: Int? = nil
    @Published var isPlaying: Bool = false
    
    func togglePlayback(for chapter: Chapter) {
        // Case 1: Tapping the already playing chapter -> Pause it
        if currentlyPlayingChapterID == chapter.id {
            if isPlaying {
                audioPlayer?.pause()
                isPlaying = false
            } else {
                audioPlayer?.play()
                isPlaying = true
            }
            return
        }
        
        // Case 2: Playing a new chapter
        guard let url = Bundle.main.url(forResource: chapter.audioFileName, withExtension: "mp3") else {
            print("Audio file \(chapter.audioFileName).mp3 not found in bundle.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            
            self.currentlyPlayingChapterID = chapter.id
            self.isPlaying = true
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }
}
