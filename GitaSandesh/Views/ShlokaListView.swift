//
//  ShlokaListView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//

import SwiftUI

struct ShlokaListView: View {
    
    let chapter: Chapter
    @StateObject private var vm = ShlokaViewModel()
    @State private var searchText = ""
    
    // MARK: - Filter Logic
    private var filteredShlokas: [Shloka] {
        let allShlokas = vm.shlokas(for: chapter.id)
        if searchText.isEmpty {
            return allShlokas
        } else {
            return allShlokas.filter { shloka in
                shloka.sanskrit.contains(searchText) ||
                "\(shloka.verse)".contains(searchText)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // MARK: - 1. Dashboard Quick Stats Header
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("अध्याय \(chapter.id)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                        
                        Text(chapter.name)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    // Quick Metric Circle
                    VStack(alignment: .center, spacing: 2) {
                        Text("\(filteredShlokas.count)")
                            .font(.title3)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(LinearGradient(colors: [.orange, .pink], startPoint: .top, endPoint: .bottom))
                            )
                        
                        Text("श्लोक")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
                
                // MARK: - 2. Search & Filter Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("श्लोक संख्या या शब्द खोजें...", text: $searchText)
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
                
                // MARK: - 3. Interactive Shloka Grid / Card Stack
                if filteredShlokas.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(.orange.opacity(0.6))
                        Text("कोई परिणाम नहीं मिला")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                } else {
                    LazyVStack(spacing: 14) {
                        ForEach(filteredShlokas) { shloka in
                            NavigationLink {
                                ShlokaDetailView(shloka: shloka)
                            } label: {
                                shlokaDashboardRow(shloka: shloka)
                            }
                            .buttonStyle(PlainButtonStyle()) // Prevents default list selection flashing
                        }
                    }
                }
            }
            .padding()
        }
        .background(
            ZStack {
                // Aesthetic Premium Gradient Base
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
                
                // Fine noise/grain background representation
                Color(.systemGroupedBackground).opacity(0.4)
                    .ignoresSafeArea()
            }
        )
        .navigationTitle("श्लोक सूची")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - 4. Beautiful Glassmorphic Card View
    @ViewBuilder
    private func shlokaDashboardRow(shloka: Shloka) -> some View {
        HStack(spacing: 16) {
            // Saffron leading edge accent stripe
            RoundedRectangle(cornerRadius: 4)
                .fill(LinearGradient(colors: [.orange, .yellow], startPoint: .top, endPoint: .bottom))
                .frame(width: 5)
                .frame(maxHeight: .infinity)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    // Modern badge for index identifier
                    Text("श्लोक \(shloka.verse)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                // Devnagari Text styling
                Text(shloka.sanskrit)
                    .font(.system(.body, design: .serif))
                    .lineLimit(2)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
            }
            .padding(.vertical, 12)
            .padding(.trailing, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.black.opacity(0.03), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
    }
}
