//
//  User.swift
//  JukeBox
//
//  Created by Maëva Bouvard on 14/06/2024.
//


import Foundation
import Fluent
import vapor


class User: ObservableObject {
    @Published var name: String
    @Published var playlists: [String: [Music]] = [
        "Combat": [],
        "Exploration": [],
        "Relaxation": []
    ]

    // Initializer
    init(name: String) {
        self.name = name
        loadPlaylistsFromUserDefaults()
    }

    // Adds music to the specified playlist and saves the updated playlists
    func addToPlaylist(_ playlist: String, music: Music) {
        if playlists[playlist] != nil {
            playlists[playlist]?.append(music)
        } else {
            playlists[playlist] = [music]
        }
        savePlaylistsToUserDefaults()
    }

    // Removes music from the specified playlist and saves the updated playlists
    func removeFromPlaylist(_ playlist: String, music: Music) {
        if playlists[playlist] != nil {
            playlists[playlist] = playlists[playlist]?.filter { $0 != music }
            savePlaylistsToUserDefaults()
        }
    }

    // Saves the playlists to UserDefaults
    private func savePlaylistsToUserDefaults() {
        let encoder = JSONEncoder()
        if let encodedPlaylists = try? encoder.encode(playlists) {
            UserDefaults.standard.set(encodedPlaylists, forKey: "playlistsData")
        }
    }

    // Loads the playlists from UserDefaults
    private func loadPlaylistsFromUserDefaults() {
        if let savedPlaylistsData = UserDefaults.standard.data(forKey: "playlistsData") {
            let decoder = JSONDecoder()
            if let loadedPlaylists = try? decoder.decode([String: [Music]].self, from: savedPlaylistsData) {
                playlists = loadedPlaylists
            }
        }
    }
    final class User: Model, Content {
        static let schema = "users"
        
        @ID(key: .id)
        var id: UUID?
        
        @Field(key: "username")
        var username: String
        
        @Field(key: "password")
        var password: String
        
        @Field(key: "email")
        var email: String

        init() { }

        init(id: UUID? = nil, username: String, password: String, email: String) {
            self.id = id
            self.username = username
            self.password = password
            self.email = email
        }
    }
}



