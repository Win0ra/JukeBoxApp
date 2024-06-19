//
//  PlaylistsView.swift
//  JukeBox
//
//  Created by Maëva Bouvard on 14/06/2024.
//

import SwiftUI
import AVFoundation

struct PlaylistsView: View {
    @EnvironmentObject var user: User
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var currentMusicIndex = 0
    @State private var currentPlaylist: [Music] = []
    @State private var audio: AVPlayer? // Utilisation de AVPlayer pour lire les fichiers audio

    var body: some View {
        List {
            ForEach(user.playlists.keys.sorted(), id: \.self) { playlist in
                Section(header: Text(playlist)) {
                    ForEach(user.playlists[playlist] ?? []) { music in
                        NavigationLink(destination: MusicDetailView(music: music)) {
                            Text(music.title)
                                .font(.headline)
                            Text(music.zone)
                                .font(.subheadline)
                        }
                    }
                    if !currentPlaylist.isEmpty && currentPlaylist == (user.playlists[playlist] ?? []) {
                        Button(action: {
                            withAnimation {
                                if isPlaying {
                                    stopMusic()
                                } else {
                                    playPlaylist(user.playlists[playlist] ?? [])
                                }
                            }
                        }) {
                            Text(isPlaying ? "Stop" : "Play Playlist")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            withAnimation {
                                playPlaylist(user.playlists[playlist] ?? [])
                            }
                        }) {
                            Text("Play Playlist")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Playlists")
        .transition(.slide)
    }

    func playPlaylist(_ playlist: [Music]) {
        guard !playlist.isEmpty else { return }
        currentPlaylist = playlist
        currentMusicIndex = 0
        playCurrentMusic()
    }

    func playCurrentMusic() {
        guard currentMusicIndex < currentPlaylist.count else {
            isPlaying = false
            return
        }
        let music = currentPlaylist[currentMusicIndex]
        if let url = Bundle.main.url(forResource: music.filename, withExtension: nil) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = AVDelegate(onFinish: {
                    self.currentMusicIndex += 1
                    self.playCurrentMusic()
                })
                audioPlayer?.play()
                isPlaying = true
            } catch {
                print("Erreur de lecture du fichier audio : \(error)")
            }
        } else {
            print("Fichier audio non trouvé : \(music.filename)")
        }
    }

    func stopMusic() {
        audioPlayer?.stop()
        isPlaying = false
        currentPlaylist.removeAll()
    }
}

class AVDelegate: NSObject, AVAudioPlayerDelegate {
    private let onFinish: () -> Void

    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onFinish()
    }
}
