//
//  User.swift
//  JukeBox
//
//  Created by Maëva Bouvard on 14/06/2024.
//

import Foundation

class User: ObservableObject {
    @Published var name: String
    @Published var playlists: [String: [Music]] = [
        "Combat": [],
        "Exploration": [],
        "Relaxation": []
    ]
    
    init(name: String) {
        self.name = name
    }
    
    func addToPlaylist(_ playlist: String, music: Music) {
        playlists[playlist]?.append(music)
    }
}
