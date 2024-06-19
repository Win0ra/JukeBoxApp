//
//  ContentView.swift
//  JukeBox
//
//  Created by Maëva Bouvard on 14/06/2024.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var searchText = ""
    @EnvironmentObject var library: MusicLibrary
    @EnvironmentObject var user: User

    @State private var isPlaying = false
    @State private var currentMusic: Music?
    @State private var audioPlayer: AVAudioPlayer?

    var filteredMusics: [Music] {
        if searchText.isEmpty {
            return library.musics
        } else {
            return library.musics.filter { $0.zone.contains(searchText) || $0.title.contains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(filteredMusics) { music in
                        NavigationLink(destination: MusicDetailView(music: music)) {
                            Text(music.title)
                                .font(.headline)
                            Text(music.zone)
                                .font(.subheadline)
                        }
                        .onTapGesture {
                            playMusic(music: music)
                        }
                    }
                }
                .navigationTitle("Jukebox WoW")
                .searchable(text: $searchText)
                .toolbar {
                    HStack {
                        Text("Hello, \(user.name)")
                            .font(.headline)
                        NavigationLink(destination: PlaylistsView()) {
                            Text("Playlists")
                        }
                    }
                }
                Spacer()
                MusicPlayerView(isPlaying: $isPlaying, currentMusic: $currentMusic, audioPlayer: audioPlayer)
            }
        }
    }

    func playMusic(music: Music) {
        if let url = Bundle.main.url(forResource: music.filename, withExtension: nil) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
                currentMusic = music
                isPlaying = true
            } catch {
                print("Erreur de lecture du fichier audio : \(error)")
            }
        } else {
            print("Fichier audio non trouvé : \(music.filename)")
        }
    }
}
