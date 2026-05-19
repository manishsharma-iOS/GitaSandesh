//
//  GeetaSandBoxApp.swift
//  GeetaSandBox
//
//  Created by Manish Sharma on 24/01/26.
//

import SwiftUI

@main
struct GeetaSandBoxApp: App {
    @StateObject var bookmarkManager = BookmarkManager()
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(bookmarkManager)
        }
    }
}
#Preview {
    MainTabView()
}
