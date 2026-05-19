//
//  ChapterMiniPlayerBar.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 05/02/26.
//
import SwiftUI
import AVFoundation

struct ChapterMiniPlayerBar: View {

    @ObservedObject var audioManager: AudioPlayerManager

    var body: some View {
        if let file = audioManager.currentFileName {
            VStack(spacing: 6) {

                // (Future) Real progress bar — placeholder for now
                ProgressView()
                    .progressViewStyle(.linear)
                    .tint(.accentColor)

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Now Playing")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(file)
                            .font(.subheadline)
                            .lineLimit(1)
                    }

                    Spacer()

                    // Play / Pause
                    Button {
                        audioManager.togglePlayPause()
                    } label: {
                        Image(systemName: audioManager.isPlaying
                              ? "pause.fill"
                              : "play.fill")
                            .font(.title2)
                    }

                    // Stop
                    Button {
                        audioManager.stop()
                    } label: {
                        Image(systemName: "stop.fill")
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(radius: 4)
            .padding()
        }
    }
}
