//
//  BookmarksView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 30/01/26.
//

import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject var bookmarkManager: BookmarkManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - 1. Bookmarks Stats Header Widget
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("प्रिय श्लोक संग्रह")
                                .font(.title3)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                            
                            Text("आपके द्वारा सहेजे गए अनमोल विचार")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Interactive Badge indicating bookmark count
                        VStack(spacing: 2) {
                            Text("\(bookmarkManager.bookmarks.count)")
                                .font(.subheadline)
                                .fontWeight(.black)
                                .foregroundColor(.white)
                                .frame(width: 38, height: 38)
                                .background(
                                    Circle()
                                        .fill(LinearGradient(colors: [.orange, .pink], startPoint: .top, endPoint: .bottom))
                                )
                            
                            Text("बुकमार्क")
                                .font(.system(size: 9))
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(18)
                    .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
                    
                    // MARK: - 2. Bookmarked Content Feed
                    if bookmarkManager.bookmarks.isEmpty {
                        emptyDashboardState
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(bookmarkManager.bookmarks) { item in
                                // Seamlessly navigate directly back to details of the verse
                                NavigationLink {
                                    ShlokaDetailView(shloka: Shloka(
                                        id : item.id,
                                        chapter: item.chapter,
                                        verse: item.verse,
                                        sanskrit: item.shloka,
                                        hindiMeaning: item.hindiMeaning,
                                        englishMeaning: item.englishMeaning
                                    ))
                                } label: {
                                    bookmarkCardRow(for: item)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding()
            }
            .background(
                ZStack {
                    // Beautiful Dashboard Gradient Backdrop matching other feeds
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
                    
                    // Unified background texture layer for depth
                    Image("paper_white")
                        .resizable()
                        .opacity(0.3)
                        .ignoresSafeArea()
                }
            )
            .navigationTitle("बुकमार्क")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Warm Spiritual Empty State
    private var emptyDashboardState: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.12))
                    .frame(width: 90, height: 90)
                
                Image(systemName: "heart.slash.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
            }
            .padding(.top, 40)
            
            VStack(spacing: 8) {
                Text("कोई बुकमार्क नहीं मिला")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("पढ़ते समय अपने पसंदीदा श्लोकों को सहेजने के लिए ऊपरी दाएं कोने में बने बुकमार्क बटन पर टैप करें।")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    // MARK: - Glassmorphic Bookmark Card Row Component
    @ViewBuilder
    private func bookmarkCardRow(for item: Bookmark) -> some View {
        HStack(spacing: 16) {
            // Saffron leading edge accent stripe
            RoundedRectangle(cornerRadius: 4)
                .fill(LinearGradient(colors: [.orange, .yellow], startPoint: .top, endPoint: .bottom))
                .frame(width: 5)
                .frame(maxHeight: .infinity)
            
            VStack(alignment: .leading, spacing: 12) {
                // Header Meta Metadata Info
                HStack {
                    Text("अध्याय \(item.chapter) • श्लोक \(item.verse)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    // Quick Action Heart Button to instantly remove with slide animations
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            bookmarkManager.remove(item)
                        }
                    } label: {
                        Image(systemName: "heart.fill")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding(8)
                            .background(Color.red.opacity(0.08))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain) // isolates tap area away from navigation container
                }
                
                // Devnagari text presentation block
                Text(item.shloka)
                    .font(.system(.body, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(6)
                
                Divider()
                    .background(Color.black.opacity(0.05))
                
                // Translated translation snippet block
                Text(item.hindiMeaning)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
            }
            .padding(.vertical, 14)
            .padding(.trailing, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.03), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}
