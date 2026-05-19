//
//  GitaWidget.swift
//  GitaWidget
//
//  Created by Manish Sharma on 16/04/26.
//

import WidgetKit
import SwiftUI


// MARK: - Widget Config
@main
struct GitaWidget: Widget {
    let kind: String = "GitaWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GitaWidgetView(entry: entry)
        }
        .configurationDisplayName("Daily Gita Shloka")
        .description("Read a new Bhagavad Gita shloka every day.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
// MARK: - Entry
struct GitaEntry: TimelineEntry {
    let date: Date
    let shloka: Shloka
}
// MARK: - Provider
struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> GitaEntry {
        GitaEntry(date: Date(), shloka: fallback())
    }

    func getSnapshot(in context: Context, completion: @escaping (GitaEntry) -> Void) {
        completion(GitaEntry(date: Date(), shloka: getTodayShloka()))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<GitaEntry>) -> Void) {
        
        let entry = GitaEntry(
            date: Date(),
            shloka: getTodayShloka()
        )
        
        let nextUpdate = Calendar.current.nextDate(
            after: Date(),
            matching: DateComponents(hour: 0),
            matchingPolicy: .nextTime
        )!
        
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}
