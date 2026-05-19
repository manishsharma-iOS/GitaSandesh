//
//  ShlokaDetailView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//
import SwiftUI

struct ShlokaDetailView: View {

    @EnvironmentObject var bookmarkManager: BookmarkManager
    @StateObject private var audioManager = AudioPlayerManager.shared

    let shloka: Shloka

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // MARK: - 1. Hero Shloka Card
                VStack(spacing: 12) {
                    HStack {
                        Text("मूल श्लोक (Sanskrit)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.12))
                            .cornerRadius(6)
                        
                        Spacer()
                    }
                    
                    Text(shloka.sanskrit)
                        .font(.system(.title3, design: .serif))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .foregroundColor(.primary)
                        .padding(.vertical, 10)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
                
                // MARK: - 2. Audio Control Dashboard Widget
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "waveform.circle.fill")
                            .font(.headline)
                            .foregroundColor(.orange)
                        
                        Text("ऑडियो व्याख्यान / Audio Recitation")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    
                    HStack(spacing: 24) {
                        // Sanskrit play button
                        audioButton(
                            title: "संस्कृत",
                            fileName: "C\(shloka.chapter)_S\(shloka.verse)_sanskrit",
                            color: .orange
                        )
                        
                        // Hindi play button (with leading zero mapping)
                        let verseStr = shloka.verse <= 9
                        ? String(format: "%02d", shloka.verse)
                        : "\(shloka.verse)"
                        
                        audioButton(
                            title: "हिन्दी",
                            fileName: "C\(shloka.chapter)_S\(verseStr)_hindi",
                            color: .green
                        )
                        
                        // English play button
                        audioButton(
                            title: "English",
                            fileName: "C\(shloka.chapter)_S\(shloka.verse)_english",
                            color: .blue
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
                
                // MARK: - 3. Interactive Interpretation Cards
                VStack(alignment: .leading, spacing: 18) {
                    
                    // Hindi Meaning Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                            Text("भावार्थ (हिन्दी)")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(shloka.hindiMeaning)
                            .font(.body)
                            .lineSpacing(6)
                            .foregroundColor(.primary)
                    }
                    
                    Divider()
                        .padding(.vertical, 4)
                    
                    // English Meaning Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                                .font(.caption)
                            Text("Translation (English)")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(shloka.englishMeaning)
                            .font(.body)
                            .lineSpacing(6)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
            }
            .padding()
        }
        .background(
            ZStack {
                // Aesthetic Premium Gradient Base (Matches Chapter detail & Shloka lists)
                LinearGradient(
                    colors: [
                        Color.orange.opacity(0.12),
                        Color.yellow.opacity(0.08),
                        Color.pink.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                Color(.systemGroupedBackground).opacity(0.4)
                    .ignoresSafeArea()
            }
        )
        .navigationTitle("अध्याय \(shloka.chapter) • श्लोक \(shloka.verse)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    toggleBookmark()
                } label: {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
            }
        }
    }
    
    // MARK: - Bookmark Helpers

    private var bookmarkID: String {
        "\(shloka.chapter)_\(shloka.verse)"
    }

    private var isBookmarked: Bool {
        bookmarkManager.isBookmarked(id: bookmarkID)
    }

    private func toggleBookmark() {
        let bookmark = Bookmark(
            id: bookmarkID,
            chapter: shloka.chapter,
            verse: shloka.verse,
            shloka: shloka.sanskrit,
            hindiMeaning: shloka.hindiMeaning,
            englishMeaning: shloka.englishMeaning
        )

        if isBookmarked {
            bookmarkManager.remove(bookmark)
        } else {
            bookmarkManager.add(bookmark)
        }
    }

    // MARK: - Beautiful Circular Audio Dial Control UI Element
    @ViewBuilder
    func audioButton(
        title: String,
        fileName: String,
        color: Color
    ) -> some View {
        
        let isPlaying = audioManager.currentFileName == fileName && audioManager.isPlaying
        let progress = audioManager.duration > 0
            ? audioManager.currentTime / audioManager.duration
            : 0
        
        VStack(spacing: 10) {
            Button {
                if audioManager.currentFileName == fileName {
                    audioManager.togglePlayPause()
                } else {
                    audioManager.playLocalAudio(fileName: fileName)
                }
            } label: {
                ZStack {
                    // Outer Soft Glow Dial Ring
                    Circle()
                        .fill(Color(.tertiarySystemGroupedBackground))
                        .frame(width: 72, height: 72)
                    
                    if isPlaying {
                        Circle()
                            .stroke(color.opacity(0.15), lineWidth: 6)
                            .frame(width: 78, height: 78)
                    }
                    
                    // Inside filled button action area
                    Circle()
                        .fill(isPlaying ? color : color.opacity(0.12))
                        .frame(width: 60, height: 60)
                    
                    // Circular Progress Dial
                    if isPlaying {
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(Color.white, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: 60, height: 60)
                            .animation(.linear(duration: 0.2), value: progress)
                    }
                    
                    // Icon inside dial
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isPlaying ? .white : color)
                }
            }
            .buttonStyle(.plain)
            
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(1)
        }
    }
}
