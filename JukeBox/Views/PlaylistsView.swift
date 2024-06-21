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
    @Binding var isPlaying: Bool
    @Binding var currentMusic: Music?
    @Binding var audioPlayer: AVAudioPlayer?
    @Binding var currentPlaylist: [Music]
    @Binding var currentMusicIndex: Int
    
    var body: some View {
        List {
            ForEach(user.playlists.keys.sorted(), id: \.self) { playlist in
                Section(header: Text(playlist)) {
                    ForEach(user.playlists[playlist] ?? []) { music in
                        HStack {
                            Text(music.title)
                                .font(.headline)
                            Spacer()
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
        .onAppear {
            loadSelectedPlaylist()
        }
    }
    
    func playPlaylist(_ playlist: [Music]) {
        guard !playlist.isEmpty else { return }
        currentPlaylist = playlist
        currentMusicIndex = 0
        playCurrentMusic()
        saveSelectedPlaylist()
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
                    if self.currentMusicIndex < self.currentPlaylist.count - 1 {
                        self.currentMusicIndex += 1
                        self.playCurrentMusic()
                    } else {
                        self.stopMusic()
                    }
                })
                audioPlayer?.play()
                currentMusic = music
                isPlaying = true
                saveSelectedPlaylist()
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
        saveSelectedPlaylist()
    }
    
    func saveSelectedPlaylist() {
//        let musicFileNames = currentPlaylist.map { $0.filename }
//        UserDefaults.standard.selectedPlaylist = musicFileNames
//        UserDefaults.standard.currentMusicIndex = currentMusicIndex
//        UserDefaults.standard.synchronize()
        
        // ---------------------------------------
        let musicFileName = currentMusic.map { $0.filename }
        UserDefaults.standard.set(musicFileName, forKey: "selectedPlaylist")
        UserDefaults.standard.set(currentMusicIndex, forKey: "currentMusicIndex")
        
    }
    
    func loadSelectedPlaylist() {
        let savedFilenames = UserDefaults.standard.array(forKey: "selectedPlaylist") ?? []
        currentPlaylist = savedFilenames.compactMap { filename in
            user.playlists.values.flatMap { $0 }.first { $0.filename == filename }
        }
        currentMusicIndex = UserDefaults.standard.integer(forKey: "currentMusicIndex")
        if !currentPlaylist.isEmpty && currentMusicIndex < currentPlaylist.count {
            playCurrentMusic()
        }
    }
}
