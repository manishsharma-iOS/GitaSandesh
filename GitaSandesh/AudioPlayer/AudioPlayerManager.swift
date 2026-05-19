//
//  AudioPlayerManager.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 03/02/26.
//
import Foundation
import AVFoundation
import SwiftUI
import Combine

final class AudioPlayerManager: ObservableObject {

    static let shared = AudioPlayerManager()

    @Published var isPlaying = false
    @Published var isPaused = false
    @Published var currentFileName: String?

    @Published var currentTime: Double = 0
    @Published var duration: Double = 1

    private var player: AVAudioPlayer?
    private var timer: AnyCancellable?

    // MARK: - Play

    func playLocalAudio(fileName: String, fileExtension: String = "mp3") {

        // If same file, toggle
        if currentFileName == fileName {
            togglePlayPause()
            return
        }

        stop()

        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: fileExtension
        ) else {
            print("❌ Audio file not found: \(fileName).\(fileExtension)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()

            currentFileName = fileName
            isPlaying = true
            isPaused = false

            duration = player?.duration ?? 1
            startTimer()

        } catch {
            print("❌ Failed to play audio: \(error)")
        }
    }

    // MARK: - Controls

    func togglePlayPause() {
        guard let player else { return }

        if player.isPlaying {
            player.pause()
            isPlaying = false
            isPaused = true
        } else {
            player.play()
            isPlaying = true
            isPaused = false
        }
    }

    func stop() {
        player?.stop()
        player = nil
        stopTimer()

        isPlaying = false
        isPaused = false
        currentFileName = nil
        currentTime = 0
        duration = 1
    }

    // MARK: - Progress / Seek

    private func startTimer() {
        stopTimer()

        timer = Timer
            .publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let player = self.player else { return }
                self.currentTime = player.currentTime
            }
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    func seek(to time: Double) {
        guard let player else { return }
        player.currentTime = time
        currentTime = time
    }
    
    
}
