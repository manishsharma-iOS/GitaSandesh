//
//  ChapterListView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//
import SwiftUI

struct ChapterListView: View {
    
    @StateObject private var vm = ChapterViewModel()
    @State private var searchText = ""
    
    // MARK: - Dynamic Filter Logic
    private var filteredChapters: [Chapter] {
        if searchText.isEmpty {
            return vm.chapters
        } else {
            return vm.chapters.filter { chapter in
                chapter.name.localizedCaseInsensitiveContains(searchText) ||
                "\(chapter.id)".contains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - 1. Global Gita Metrics Widget
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("श्रीमद्भगवद्गीता")
                                .font(.title3)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                            
                            Text("ईश्वर का शाश्वत संदेश")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Numeric Badge Stats
                        HStack(spacing: 12) {
                            metricBadge(value: "18", title: "अध्याय")
                            metricBadge(value: "700", title: "श्लोक")
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(18)
                    .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
                    
                    // MARK: - 2. Elegant Search & Filter Control
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("अध्याय का नाम या संख्या खोजें...", text: $searchText)
                            .font(.body)
                            .autocorrectionDisabled()
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground).opacity(0.95))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.orange.opacity(0.25), lineWidth: 1)
                    )
                    
                    // MARK: - 3. Interactive Chapter Grid Stack
                    if filteredChapters.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 40))
                                .foregroundColor(.orange.opacity(0.6))
                            Text("कोई अध्याय नहीं मिला")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 40)
                    } else {
                        LazyVStack(spacing: 14) {
                            ForEach(filteredChapters) { chapter in
                                NavigationLink {
                                    ChapterDetailView(chapter: chapter)
                                } label: {
                                    chapterDashboardRow(chapter: chapter)
                                }
                                .buttonStyle(PlainButtonStyle()) // Cleans tap-states
                            }
                        }
                    }
                }
                .padding()
            }
            .background(
                ZStack {
                    // Beautiful Dashboard Gradient Backdrop
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
                    
                    // Unified asset background layer blended smoothly
                    Image("paper_white")
                        .resizable()
                        .opacity(0.3)
                        .ignoresSafeArea()
                }
            )
            .navigationTitle("मुख्य पृष्ठ")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Reusable UI Components
    
    @ViewBuilder
    private func metricBadge(value: String, title: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.subheadline)
                .fontWeight(.black)
                .foregroundColor(.white)
                .frame(width: 38, height: 38)
                .background(
                    Circle()
                        .fill(LinearGradient(colors: [.orange, .pink], startPoint: .top, endPoint: .bottom))
                )
            
            Text(title)
                .font(.system(size: 9))
                .fontWeight(.bold)
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private func chapterDashboardRow(chapter: Chapter) -> some View {
        HStack(spacing: 16) {
            // Elegant leading aesthetic strip
            RoundedRectangle(cornerRadius: 4)
                .fill(LinearGradient(colors: [.orange, .yellow], startPoint: .top, endPoint: .bottom))
                .frame(width: 5)
                .frame(maxHeight: .infinity)
            
            // Chapter Circular Badge ID
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.12))
                    .frame(width: 44, height: 44)
                
                Text("\(chapter.id)")
                    .font(.system(.headline, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(chapter.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Image(systemName: "list.bullet.indent")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text("अध्याय \(chapter.id) • \(chapter.totalVerses) श्लोक")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.03), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
    }
}
