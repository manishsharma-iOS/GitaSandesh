//
//  MiniPlayerBarView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 03/02/26.
//
import SwiftUI
import Combine

struct MiniPlayerBarView: View {

    @StateObject private var audioManager = AudioPlayerManager.shared

    var body: some View {
        if let file = audioManager.currentFileName {
            VStack(spacing: 0) {

                // Ultra-thin Spotify style progress
                Slider(
                    value: Binding(
                        get: { audioManager.currentTime },
                        set: { audioManager.seek(to: $0) }
                    ),
                    in: 0...max(audioManager.duration, 0.1)
                )
                .tint(.green)
                .scaleEffect(x: 1, y: 0.6)
                .padding(.horizontal, 6)

                HStack(spacing: 12) {

                    // Album Art
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [.purple, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "music.note")
                                .foregroundColor(.white)
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Chapter Audio")
                            .font(.headline)
                            .lineLimit(1)

                        Text(file)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    // Play / Pause
                    Button {
                        audioManager.togglePlayPause()
                    } label: {
                        Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title2)
                            .contentTransition(.symbolEffect(.replace))

                    }

                    // Stop
                    Button {
                        audioManager.stop()
                    } label: {
                        Image(systemName: "stop.fill")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.85),
                       value: audioManager.currentFileName)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.25), radius: 10, y: -2)
            .padding(.horizontal)
            .padding(.bottom, 58)
           // .padding(.bottom, 50 + UIApplication.bottomSafeArea)

            .transition(.move(edge: .bottom))
            
        }
    }
}
//extension UIApplication {
//    static var bottomSafeArea: CGFloat {
//        let window = UIApplication.shared
//            .connectedScenes
//            .compactMap { $0 as? UIWindowScene }
//            .first?
//            .windows
//            .first
//
//        return window?.safeAreaInsets.bottom ?? 0
//    }
//}
