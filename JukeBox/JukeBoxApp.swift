//
//  JukeBoxApp.swift
//  JukeBox
//
//  Created by Maëva Bouvard on 14/06/2024.
//

import SwiftUI

@main
struct JukeboxWoWApp: App {
    @StateObject private var user = User(name: "Player1")
    @StateObject private var library = MusicLibrary()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
                .environmentObject(library)
        }
    }
}
