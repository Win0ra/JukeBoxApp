//
//  MusicDetailView.swift
//  JukeBox
//
//  Created by Maëva Bouvard on 14/06/2024.
//

import SwiftUI
import AVFoundation

struct MusicDetailView: View {
    var music: Music
    @State private var audioPlayer: AVAudioPlayer?
    @EnvironmentObject var library: MusicLibrary
    @EnvironmentObject var user: User
    @State private var selectedPlaylist = "Combat"

    var body: some View {
        VStack(alignment: .leading) {
            Text(music.title)
                .font(.largeTitle)
                .padding()
            Text("Zone: \(music.zone)")
                .font(.headline)
                .padding()
            Text("Composer: \(music.composer)")
                .font(.subheadline)
                .padding()
            Text(music.description)
                .padding()
            Button("Play") {
                playMusic(filename: music.filename)
            }
            .padding()
            
            Picker("Add to Playlist", selection: $selectedPlaylist) {
                ForEach(user.playlists.keys.sorted(), id: \.self) { playlist in
                    Text(playlist)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button("Add to \(selectedPlaylist) Playlist") {
                user.addToPlaylist(selectedPlaylist, music: music)
            }
            .padding()
        }
        .navigationTitle(music.title)
        .transition(.slide)
        .animation(.default)
    }

    func playMusic(filename: String) {
        if let path = Bundle.main.path(forResource: filename, ofType: nil) {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Erreur de lecture du fichier audio.")
            }
        }
    }
}
