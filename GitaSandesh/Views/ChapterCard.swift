//
//  ChapterCard.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 23/04/26.
//
import SwiftUI

struct ChapterCard: View {
    let group: [Chapter]
    
    // Connect directly to your existing global audio player manager
    @ObservedObject private var audioManager = AudioPlayerManager.shared
    
    var body: some View {
        VStack(spacing: 14) {
            ForEach(group) { chapter in
                HStack(spacing: 12) {
                    
                    // 1. Navigation link for everything except the play button
                    NavigationLink(destination: ChapterDetailView(chapter: chapter)) {
                        HStack(spacing: 12) {
                            // Saffron numerical index circle
                            ZStack {
                                Circle()
                                    .fill(Color.orange.opacity(0.12))
                                    .frame(width: 36, height: 36)
                                Text("\(chapter.id)")
                                    .font(.system(.subheadline, design: .serif))
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(chapter.name)
                                    .font(.system(.subheadline, weight: .bold))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                
                                Text("अध्याय \(chapter.id) • \(chapter.totalVerses) श्लोक")
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain) // Keeps text colors normal, not blue
                    
                    // 2. Play/Pause toggle bound directly to AudioPlayerManager
                    Button(action: {
                        // Triggers your custom playLocalAudio logic
                        audioManager.playLocalAudio(fileName: chapter.audioFileName)
                    }) {
                        ZStack {
                            let isThisChapterPlaying = audioManager.currentFileName == chapter.audioFileName && audioManager.isPlaying
                            
                            Circle()
                                .fill(isThisChapterPlaying ? Color.orange : Color.clear)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(Color.orange.opacity(isThisChapterPlaying ? 0 : 0.3), lineWidth: 1)
                                )
                            
                            Image(systemName: isThisChapterPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 11, weight: .bold))
                                .offset(x: isThisChapterPlaying ? 0 : 1) // Centers the play triangle visually
                                .foregroundColor(isThisChapterPlaying ? .white : .orange)
                        }
                    }
                    .buttonStyle(.borderless) // CRITICAL: Isolates tap gesture from the NavigationLink row
                    
                    // 3. Simple navigation hint
                    Image(systemName: "leaf")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary.opacity(0.4))
                }
                
                if chapter.id != group.last?.id {
                    Divider().background(Color.primary.opacity(0.06))
                }
            }
        }
        .padding(16)
        .frame(width: 290) // Enhanced breathing room for title, play button, and chevron
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemGroupedBackground).opacity(0.85))
                .background(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.orange.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
    }
}
