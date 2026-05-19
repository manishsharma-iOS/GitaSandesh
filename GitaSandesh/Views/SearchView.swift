//
//  SearchView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 15/04/26.
//

import SwiftUI

// MARK: - MAIN SEARCH VIEW

struct SearchView: View {
    
    @StateObject private var vm = ShlokaViewModel()
    @State private var searchText = ""
    @State private var results: [Shloka] = []
    @EnvironmentObject var bookmarkManager: BookmarkManager
    
    // Quick search recommendation tags matching scriptural intent
    private let searchSuggestions = [
        "कर्म योग", "भक्ति", "Mental Peace", "2.47", "अध्याय 4", "Soul"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: App Background Layer
                Image("paper_white")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // 🔍 Professional Search Input Bar
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.orange)
                                .font(.system(size: 16, weight: .bold))
                            
                            TextField("खोजें (Hindi / English / Sanskrit) या जैसे 2.47", text: $searchText)
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .keyboardType(.default)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .onChange(of: searchText) { oldValue, newValue in
                                    results = vm.search(query: newValue)
                                }
                            
                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                    results = []
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.black.opacity(0.4))
                                }
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.black.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
                    }
                    .padding()
                    .background(Color.white.opacity(0.4).background(.ultraThinMaterial))
                    
                    // MARK: Content Router Layer
                    if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        placeholderSuggestionsView
                    } else if results.isEmpty {
                        emptyStateResultsView
                    } else {
                        searchResultsListView
                    }
                }
            }
            .navigationTitle("श्लोक खोजें")
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

// MARK: - MODULE EXTENSIONS

extension SearchView {
    
    // MARK: Placeholder / Search Guidelines Interface
    private var placeholderSuggestionsView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 12) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 56))
                    .foregroundColor(.orange.opacity(0.6))
                
                Text("त्वरित खोज मार्गदर्शिका")
                    .font(.system(.headline, design: .serif))
                    .foregroundColor(.black)
                
                Text("आप हिंदी अर्थ, अंग्रेजी अनुवाद, विशिष्ट संस्कृत शब्द या सीधे अध्याय और श्लोक संख्या (जैसे 2.47) लिखकर खोज सकते हैं।")
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }
            
            // Suggestion grid chips layout using the compiler-safe layout engine
            VStack(alignment: .leading, spacing: 12) {
                Text("लोकप्रिय खोजें:")
                    .font(.caption.bold())
                    .foregroundColor(.black.opacity(0.4))
                    .padding(.horizontal, 6)
                
                FlowLayout(spacing: 10) {
                    ForEach(searchSuggestions, id: \.self) { suggestion in
                        Button {
                            searchText = suggestion
                        } label: {
                            Text(suggestion)
                                .font(.subheadline)
                                .foregroundColor(.black.opacity(0.85))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    ZStack {
                                        Image("paper_bg")
                                            .resizable()
                                        Color.white.opacity(0.3)
                                    }
                                )
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.black.opacity(0.08), lineWidth: 1))
                                .shadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
    
    // MARK: Empty Search Yield
    private var emptyStateResultsView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.red.opacity(0.5))
            
            Text("कोई परिणाम नहीं मिला")
                .font(.headline)
                .foregroundColor(.black.opacity(0.6))
            
            Text("कृपया कोई दूसरा कीवर्ड या अध्याय संख्या टाइप करके देखें।")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.4))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }
    
    // MARK: Interactive Dynamic Results Feed
    private var searchResultsListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(results) { shloka in
                    searchCard(shloka)
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
    }
    
    // MARK: Unified Shloka Card Component
    private func searchCard(_ shloka: Shloka) -> some View {
        let id = "\(shloka.chapter)_\(shloka.verse)"
        
        return VStack(alignment: .leading, spacing: 14) {
            
            // 🔖 Top metadata tracking header
            HStack {
                Text("अध्याय \(shloka.chapter) • श्लोक \(shloka.verse)")
                    .font(.caption.bold())
                    .foregroundColor(.orange)
                
                Spacer()
                
                Button {
                    toggleBookmark(shloka)
                } label: {
                    Image(systemName: bookmarkManager.isBookmarked(id: id) ? "bookmark.fill" : "bookmark")
                        .foregroundColor(.orange)
                        .font(.system(size: 16))
                        .scaleEffect(bookmarkManager.isBookmarked(id: id) ? 1.15 : 1.0)
                }
            }
            
            // 📜 Traditional Devnagari Script Render
            Text(shloka.sanskrit)
                .font(.system(size: 19, weight: .bold, design: .serif))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider().background(Color.black.opacity(0.08))
            
            // 🇮🇳 Hindi Verse Context Meaning
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 6) {
                    Text("हिन्दी:")
                        .font(.caption.bold())
                        .foregroundColor(.orange.opacity(0.8))
                    Text(shloka.hindiMeaning)
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.75))
                        .lineSpacing(4)
                }
                
                // 🇬🇧 Global Structural Translation
                HStack(alignment: .top, spacing: 6) {
                    Text("English:")
                        .font(.caption.bold())
                        .foregroundColor(.orange.opacity(0.8))
                    Text(shloka.englishMeaning)
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.7))
                        .lineSpacing(4)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                Image("paper_bg")
                    .resizable()
                    .scaledToFill()
                Color.white.opacity(0.15)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
    }
    
    private func toggleBookmark(_ shloka: Shloka) {
        let id = "\(shloka.chapter)_\(shloka.verse)"
        let bookmark = Bookmark(
            id: id,
            chapter: shloka.chapter,
            verse: shloka.verse,
            shloka: shloka.sanskrit,
            hindiMeaning: shloka.hindiMeaning,
            englishMeaning: shloka.englishMeaning
        )
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.70)) {
            if bookmarkManager.isBookmarked(id: id) {
                bookmarkManager.remove(bookmark)
            } else {
                bookmarkManager.add(bookmark)
            }
        }
    }
}

// MARK: - COMPILER-SAFE NATIVE FLOW LAYOUT

/// Custom Layout implementation that natively wraps dynamic views inline horizontally.
struct FlowLayout: Layout {
    var spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let width = proposal.width ?? .infinity
        
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxRowHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        
        for size in sizes {
            if currentX + size.width > width {
                currentX = 0
                currentY += maxRowHeight + spacing
                maxRowHeight = 0
            }
            
            currentX += size.width + spacing
            maxRowHeight = max(maxRowHeight, size.height)
            totalWidth = max(totalWidth, currentX)
        }
        
        return CGSize(width: totalWidth, height: currentY + maxRowHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var maxRowHeight: CGFloat = 0
        
        for index in subviews.indices {
            let size = sizes[index]
            
            if currentX + size.width > bounds.maxX {
                currentX = bounds.minX
                currentY += maxRowHeight + spacing
                maxRowHeight = 0
            }
            
            subviews[index].place(
                at: CGPoint(x: currentX, y: currentY),
                proposal: ProposedViewSize(size)
            )
            
            currentX += size.width + spacing
            maxRowHeight = max(maxRowHeight, size.height)
        }
    }
}
