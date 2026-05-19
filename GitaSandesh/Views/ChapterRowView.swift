//
//  ChapterRowView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 03/02/26.
//

import SwiftUI
import AVFoundation

struct ChapterRowView: View {
    
    let chapter: Chapter
    @ObservedObject var audioManager = AudioPlayerManager.shared
    
    // MARK: - Helpers
    
    var isPlayingThisChapter: Bool {
        audioManager.currentFileName == chapter.audioFileName
        && audioManager.isPlaying
    }
    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading, spacing: 4) {
                Text("अध्याय \(chapter.id)")
                    .font(.headline)
                
                Text(chapter.name)
                    .font(.subheadline)
                
                Text(chapter.summary)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 🎧 Audio Button
            Button {
                audioManager.playLocalAudio(fileName: chapter.audioFileName)
            } label: {
                Image(systemName: isPlayingThisChapter
                      ? "pause.circle.fill"
                      : "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(isPlayingThisChapter ? .red : .blue)
            }

        }
        .padding(.vertical, 6)
    }
}
