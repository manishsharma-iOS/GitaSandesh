//
//  ChapterDetailView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//
import SwiftUI
import AVFoundation

struct ChapterDetailView: View {
    
    @StateObject private var audioManager = AudioPlayerManager.shared
    
    let chapter: Chapter
    
    // MARK: - Helpers
    private var isPlayingThisChapter: Bool {
        audioManager.currentFileName == chapter.audioFileName && audioManager.isPlaying
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // MARK: - Header Meta Card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("अध्याय \(chapter.id)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.15))
                            .foregroundColor(.orange)
                            .cornerRadius(8)
                        
                        Spacer()
                        
                        Text("स्वामी अड़गड़ानंद जी महाराज")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(chapter.name)
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                
                // MARK: - Audio Player Dashboard Widget
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(isPlayingThisChapter ? "NOW PLAYING" : "AUDIO LESSON")
                            .font(.caption2)
                            .fontWeight(.heavy)
                            .foregroundColor(isPlayingThisChapter ? .red : .secondary)
                            .tracking(1)
                        
                        Text(chapter.name)
                            .font(.headline)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    // Dashboard Style Control Button
                    Button {
                        if isPlayingThisChapter {
                            audioManager.togglePlayPause()
                            // Assuming your manager has a pause method
                        } else {
                            audioManager.playLocalAudio(fileName: chapter.audioFileName)
                        }
                    } label: {
                        Image(systemName: isPlayingThisChapter ? "pause.fill" : "play.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(16)
                            .background(isPlayingThisChapter ? Color.red : Color.blue)
                            .clipShape(Circle())
                            .shadow(color: (isPlayingThisChapter ? Color.red : Color.blue).opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                
                // MARK: - Content / Summary Cards
                VStack(alignment: .leading, spacing: 16) {
                    dashboardSectionHeader(title: "सारांश (Hindi)", icon: "doc.text.magnifyingglass")
                    
                    Text(chapter.summary)
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundColor(.primary)
                    
                    Divider()
                        .padding(.vertical, 4)
                    
                    dashboardSectionHeader(title: "Summary (English)", icon: "globe")
                    
                    Text(chapter.summary_eng)
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                
                // MARK: - Action Navigation Button
                NavigationLink {
                    ShlokaListView(chapter: chapter)
                } label: {
                    HStack {
                        Image(systemName: "book.fill")
                        Text("श्लोक देखें")
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(14)
                    .shadow(color: Color.orange.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.top, 8)
                
            }
            .padding()
        }
        .background(
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                // Blends your paper asset softly into the background for texture
                Image("paper_white")
                    .resizable()
                    .opacity(0.4)
                    .ignoresSafeArea()
            }
        )
        .navigationTitle("अध्याय विवरण")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Helper view for clean dashboard card headers
    private func dashboardSectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.footnote)
                .foregroundColor(.orange)
            Text(title)
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
        }
    }
}
