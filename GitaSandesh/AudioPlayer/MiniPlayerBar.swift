//
//  MiniPlayerBar.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 05/02/26.
//
import SwiftUI

struct MiniPlayerBar: View {

    @ObservedObject var speechManager: SpeechManager

    var body: some View {
        if speechManager.currentText != nil {
            VStack(spacing: 0) {

                // Ultra-thin Spotify style progress (SAME as Audio Player)
                Slider(
                    value: Binding(
                        get: { speechManager.progress },
                        set: { _ in } // read-only visual slider
                    ),
                    in: 0...1
                )
                .tint(.green)
                .scaleEffect(x: 1, y: 0.6)
                .padding(.horizontal, 6)

                HStack(spacing: 12) {

                    // Icon (like album art)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundColor(.white)
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Now Speaking")
                            .font(.headline)
                            .lineLimit(1)

                        Text(speechManager.currentText?.prefix(40) ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    // Play / Pause
                    Button {
                        if speechManager.isSpeaking {
                            speechManager.pause()
                        } else if speechManager.isPaused {
                            speechManager.resume()
                        }
                    } label: {
                        Image(systemName: speechManager.isSpeaking
                              ? "pause.fill"
                              : "play.fill")
                            .font(.title2)
                    }

                    // Stop
                    Button {
                        speechManager.stop()
                    } label: {
                        Image(systemName: "stop.fill")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.25), radius: 10, y: -2)
            .padding(.horizontal)
            .padding(.top, 6)
            .padding(.bottom, 60) // 👈 Above TabBar (same as audio)
            .transition(.move(edge: .bottom))
            .animation(.spring(response: 0.35, dampingFraction: 0.85),
                       value: speechManager.currentText)
        }
    }
}
