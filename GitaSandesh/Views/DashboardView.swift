//
//  DashboardView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//

import SwiftUI
import WidgetKit

struct DashboardView: View {
    
    @EnvironmentObject var bookmarkManager: BookmarkManager
    @StateObject private var vm = ShlokaViewModel()
    @StateObject private var audioManager = AudioPlayerManager.shared
    
    @State private var shloka: Shloka?
    @State private var history: [Shloka] = []
    
    @AppStorage("hasSeenGuide") private var hasSeenGuide = false
    @State private var showGuide = false
    
    @StateObject private var cvm = ChapterViewModel()
    
    var groupedChapters: [[Chapter]] {
        cvm.chapters.chunked(into: 6)
    }
    
    // MARK: - Language Enum
    enum MeaningLanguage: String, CaseIterable {
        case sanskrit = "संस्कृत"
        case hindi = "हिंदी"
        case english = "English"
    }
    
    var body: some View {
        ZStack {
            // Ambient Dashboard Gradient Backdrop
            LinearGradient(
                colors: [
                    Color.orange.opacity(0.14),
                    Color.yellow.opacity(0.08),
                    Color.pink.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Warm unified parchment paper layer
            Image("paper_white")
                .resizable()
                .opacity(0.2)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // Welcome & Spiritual Greeting Header
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("राधे राधे 🙏")
                                .font(.system(.subheadline, design: .serif))
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                            
                            Text("आज का श्लोक")
                                .font(.system(.title, design: .serif))
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        // Interactive Quick-Stats Badge
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .font(.footnote)
                                .foregroundColor(.orange)
                            Text("दैनिक प्रेरणा")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.orange.opacity(0.12))
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    if let shloka = shloka {
                        TabView {
                            ForEach(MeaningLanguage.allCases, id: \.self) { lang in
                                languageCard(shloka: shloka, language: lang)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 32) // reserves pagination dot spaces
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .automatic))
                        .frame(height: 440)
                        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
                        // Swipe-to-traverse gestures
                        .gesture(
                            DragGesture(minimumDistance: 40)
                                .onEnded { value in
                                    if value.translation.width < -80 {
                                        nextShloka()
                                    } else if value.translation.width > 80 {
                                        previousShloka()
                                    }
                                }
                        )
                        
                        // Carousel Section Header
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("श्रीमद्भगवद्गीता")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                                
                                Text("संपूर्ण १८ अध्याय")
                                    .font(.system(.title3, design: .serif))
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // Horizontal Interactive Carousel
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 16) {
                                ForEach(groupedChapters, id: \.self) { group in
                                    ChapterCard(group: group)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .safeAreaPadding(.horizontal, 16)
                    } else {
                        // Soft loading placeholder widget
                        ProgressView()
                            .tint(.orange)
                            .frame(height: 350)
                    }
                }
                .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if showGuide {
                guideView
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .onAppear {
            initializeDashboard()
        }
    }
}



// MARK: - COMPONENT: LANGUAGE CARD
private extension DashboardView {
    
    func languageCard(shloka: Shloka, language: MeaningLanguage) -> some View {
        VStack(spacing: 16) {
            
            // Header: Verse coordinates + Heart toggle
            HStack {
                Text("अध्याय \(shloka.chapter) • श्लोक \(shloka.verse)")
                    .font(.system(.caption, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(6)
                
                Spacer()
                
                bookmarkButton(for: shloka)
            }
            
            // Translation Title Badge
            Text(language.rawValue)
                .font(.system(.subheadline, design: .serif))
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            
            Spacer(minLength: 0)
            
            // Content text area (Devnagari optimized fonts)
            Text(textForLanguage(shloka, language))
                .font(
                    language == .sanskrit
                    ? .system(size: 21, weight: .bold, design: .serif)
                    : .system(size: 17, weight: .semibold, design: .default)
                )
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 8)
            
            Spacer(minLength: 0)
            
            Divider()
                .background(Color.primary.opacity(0.08))
            
            // Beautiful Concentric Playback Controller
            HStack(spacing: 12) {
                Text("ऑडियो सुनें")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                audioButton(
                    fileName: audioFileName(shloka, language),
                    color: .orange
                )
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.secondarySystemGroupedBackground).opacity(0.85))
                .background(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.orange.opacity(0.15), lineWidth: 1)
        )
        // Double Tap Shortcut Gesture: Heart/Bookmark instantly
        .onTapGesture(count: 2) {
            toggleBookmark(shloka)
            triggerSelectionFeedback()
        }
    }
}

// MARK: - CONTROLS & COMPUTATIONS
private extension DashboardView {
    
    func textForLanguage(_ shloka: Shloka, _ lang: MeaningLanguage) -> String {
        switch lang {
        case .sanskrit: return shloka.sanskrit
        case .hindi: return shloka.hindiMeaning
        case .english: return shloka.englishMeaning
        }
    }
    
    func audioFileName(_ shloka: Shloka, _ lang: MeaningLanguage) -> String {
        let verseStr = String(format: "%02d", shloka.verse)
        
        switch lang {
        case .sanskrit:
            return "C\(shloka.chapter)_S\(shloka.verse)_sanskrit"
        case .hindi:
            return "C\(shloka.chapter)_S\(verseStr)_hindi"
        case .english:
            return "C\(shloka.chapter)_S\(shloka.verse)_english"
        }
    }
}

// MARK: - NAVIGATION ENGINE
private extension DashboardView {
    
    func nextShloka() {
        guard let current = shloka else { return }
        history.append(current)
        triggerSelectionFeedback()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            shloka = vm.randomShloka()
            if let shloka = shloka {
                saveSelectedShloka(shloka)
            }
        }
    }
    
    func previousShloka() {
        guard let last = history.popLast() else { return }
        triggerSelectionFeedback()
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            shloka = last
            saveSelectedShloka(last)
        }
    }
}

// MARK: - BOOKMARKS & REACTION PORT
private extension DashboardView {
    
    func bookmarkButton(for shloka: Shloka) -> some View {
        let id = "\(shloka.chapter)_\(shloka.verse)"
        let isSaved = bookmarkManager.isBookmarked(id: id)
        
        return Button {
            toggleBookmark(shloka)
        } label: {
            Image(systemName: isSaved ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundColor(isSaved ? .red : .secondary)
                .scaleEffect(isSaved ? 1.15 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSaved)
                .padding(8)
                .background(isSaved ? Color.red.opacity(0.1) : Color.black.opacity(0.03))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
    
    func toggleBookmark(_ shloka: Shloka) {
        let id = "\(shloka.chapter)_\(shloka.verse)"
        
        let bookmark = Bookmark(
            id: id,
            chapter: shloka.chapter,
            verse: shloka.verse,
            shloka: shloka.sanskrit,
            hindiMeaning: shloka.hindiMeaning,
            englishMeaning: shloka.englishMeaning
        )
        
        if bookmarkManager.isBookmarked(id: id) {
            bookmarkManager.remove(bookmark)
        } else {
            bookmarkManager.add(bookmark)
        }
    }
}

// MARK: - AUDIO SYSTEM
private extension DashboardView {
    
    func audioButton(fileName: String, color: Color) -> some View {
        let isPlaying = audioManager.currentFileName == fileName && audioManager.isPlaying
        let progress = audioManager.duration > 0 ? audioManager.currentTime / audioManager.duration : 0
        
        return Button {
            if audioManager.currentFileName == fileName {
                audioManager.togglePlayPause()
            } else {
                audioManager.playLocalAudio(fileName: fileName)
            }
        } label: {
            ZStack {
                // Glow Halo Ring
                Circle()
                    .fill(isPlaying ? color.opacity(0.12) : Color.black.opacity(0.04))
                    .frame(width: 44, height: 44)
                
                // Track Progress Arc
                if isPlaying {
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 44, height: 44)
                        .animation(.linear(duration: 0.1), value: progress)
                }
                
                // Central Action Disc
                Circle()
                    .fill(isPlaying ? color : color.opacity(0.12))
                    .frame(width: 34, height: 34)
                
                // Icon representation
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(isPlaying ? .white : color)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - ONBOARDING TUTORIAL MODAL
private extension DashboardView {
    
    var guideView: some View {
        ZStack {
            // High-fidelity backdrop blur
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
            
            VStack(spacing: 24) {
                // Sacred Lamp Mandala Badge
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 80, height: 80)
                    Text("🪔")
                        .font(.system(size: 40))
                }
                
                VStack(spacing: 6) {
                    Text("स्वाध्याय मार्ग")
                        .font(.system(.title2, design: .serif))
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                    
                    Text("गीता स्वाध्याय के सहज संकेत")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Visual Interaction Row Map
                VStack(spacing: 16) {
                    guideRow(icon: "hand.tap.fill", title: "दो बार दबाएं (Double Tap)", desc: "पसंदीदा श्लोक बुकमार्क करें")
                    guideRow(icon: "arrow.left.and.right", title: "दाएं/बाएं स्वाइप (Swipe)", desc: "पिछले अथवा अगले श्लोक पर जाएं")
                    guideRow(icon: "waveform", title: "ऑडियो नियंत्रण", desc: "संस्कृत, हिंदी व अंग्रेजी पाठ सुनें")
                }
                .padding(.vertical, 8)
                
                // Action Dismiss button
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        hasSeenGuide = true
                        showGuide = false
                    }
                } label: {
                    Text("समझ गया 👍")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(14)
                        .shadow(color: Color.orange.opacity(0.3), radius: 6, x: 0, y: 3)
                }
            }
            .padding(26)
            .background(Color(.systemBackground))
            .cornerRadius(28)
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.orange.opacity(0.15), lineWidth: 1)
            )
            .padding(.horizontal, 32)
        }
    }
    
    func guideRow(icon: String, title: String, desc: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.orange)
                .frame(width: 32, height: 32)
                .background(Color.orange.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.primary)
                Text(desc)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}

// MARK: - SYSTEM LIFECYCLE & SYNC
private extension DashboardView {
    
    func initializeDashboard() {
        shloka = vm.randomShloka()
        saveShlokasToShared()
        
        if let shloka = shloka {
            saveSelectedShloka(shloka)
        }
        
        if !hasSeenGuide {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    showGuide = true
                }
            }
        }
    }
    
    func triggerSelectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    func saveShlokasToShared() {
        let shlokas = vm.shlokas
        guard !shlokas.isEmpty else { return }
        
        let defaults = UserDefaults(suiteName: "group.com.manish.GitaSandesh")
        if let encoded = try? JSONEncoder().encode(shlokas) {
            defaults?.set(encoded, forKey: "shloka_list")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    func saveSelectedShloka(_ shloka: Shloka) {
        let defaults = UserDefaults(suiteName: "group.com.manish.GitaSandesh")
        if let encoded = try? JSONEncoder().encode(shloka) {
            defaults?.set(encoded, forKey: "selected_shloka")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

// MARK: - EXTENSION: ARRAY CHUNK
// Placing this outside of the DashboardView struct scope allows Swift to expose the
// chunked helper globally to all Arrays in your project.
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
