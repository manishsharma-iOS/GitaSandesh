//
//  GitaWidgetView.swift
//  GeetaSandBox
//  Created by Manish Sharma on 16/04/26.
//
import SwiftUI
import WidgetKit

struct GitaWidgetView: View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            // 🔸 Header
            HStack {
                Text("आज का श्लोक")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                
                Spacer()
  
            }
            
            // 🕉️ Sanskrit (Primary Content)
            Text(entry.shloka.sanskrit)
                .font(primaryFont)
                .foregroundStyle(.white)
                .lineLimit(lineLimit)
                .minimumScaleFactor(0.75)
            
            Spacer(minLength: 4)
 
        }
        .padding(contentPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        
        // 🍎 ONLY background (no extra cards)
        .containerBackground(for: .widget) {
            LinearGradient(
                colors: [
                    Color.orange,
                    Color.pink,
                    Color.purple
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        .widgetURL(URL(string: "gita://shloka/\(entry.shloka.id)"))
    }
}
private extension GitaWidgetView {
    
    var contentPadding: CGFloat {
        switch family {
        case .systemSmall: return 12
        case .systemMedium: return 14
        case .systemLarge: return 16
        default: return 14
        }
    }
    
    var primaryFont: Font {
        switch family {
        case .systemSmall:
            return .system(size: 13, weight: .semibold)
        case .systemMedium:
            return .system(size: 15, weight: .semibold)
        case .systemLarge:
            return .system(size: 18, weight: .bold)
        default:
            return .system(size: 14, weight: .semibold)
        }
    }
    
    var lineLimit: Int {
        switch family {
        case .systemSmall: return 3
        case .systemMedium: return 4
        case .systemLarge: return 6
        default: return 4
        }
    }
}

