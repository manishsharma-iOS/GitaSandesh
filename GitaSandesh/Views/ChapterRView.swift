//
//  ChapterRlView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 23/04/26.
//
import SwiftUI

struct ChapterRView: View {
    let chapter: Chapter
    let onPlay: (Chapter) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 36, height: 36)
                
                Text("\(chapter.id)")
                    .font(.subheadline.bold())
                    .foregroundColor(.orange)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(chapter.name)
                    .font(.subheadline.bold())
                    .lineLimit(1)
                
                Text("अध्याय \(chapter.id)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                onPlay(chapter)
            } label: {
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(.orange)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.2))
        )
    }
}
