//
//  GitaWidgetLiveActivity.swift
//  GitaWidget
//
//  Created by Manish Sharma on 16/04/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct GitaWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct GitaWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GitaWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension GitaWidgetAttributes {
    fileprivate static var preview: GitaWidgetAttributes {
        GitaWidgetAttributes(name: "World")
    }
}

extension GitaWidgetAttributes.ContentState {
    fileprivate static var smiley: GitaWidgetAttributes.ContentState {
        GitaWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: GitaWidgetAttributes.ContentState {
         GitaWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: GitaWidgetAttributes.preview) {
   GitaWidgetLiveActivity()
} contentStates: {
    GitaWidgetAttributes.ContentState.smiley
    GitaWidgetAttributes.ContentState.starEyes
}
