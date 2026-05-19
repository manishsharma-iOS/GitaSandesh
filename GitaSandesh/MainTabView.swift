//
//  MainTabView.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tabItem {
                        Label("आज का श्लोक", systemImage: "house.fill")
                    }
                    .tag(0)
                
                ChapterListView()
                    .tabItem {
                        Label("संपूर्ण गीता", systemImage: "book.fill")
                    }
                    .tag(1)
                
                BookmarksView()
                    .tabItem {
                        Label("श्लोक स्मृति", systemImage: "star.fill")
                    }
                    .tag(2)
                //                CharactersView()
                //                    .tabItem {
                //                        Label("पात्र", systemImage: "person.3.fill")
                //                    }
//                AskKrishnaView()
//                    .tabItem {
//                        Image(systemName: "magnifyingglass")
//                        Text("Ask Krishna")
//                    }
                KrishnaChatView()
                    .tabItem {
                        Image(systemName: "hands.sparkles.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .yellow],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .font(.title2)
                        Text("Ask Krishna")
                    }
//                SearchView()
//                    .tabItem {
//                        Image(systemName: "magnifyingglass")
//                        Text("Search")
//                    }
                
            }//
            .onChange(of: selectedTab) { _,_ in
                triggerHaptic()
            }
            // Spacer()
            VStack {
                Spacer()
                MiniPlayerBarView()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    func triggerHaptic() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
