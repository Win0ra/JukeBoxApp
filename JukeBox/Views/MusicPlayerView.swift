//
//  MusicPlayerView.swift
//  JukeBox
//
//  Created by Maëva Bouvard on 18/06/2024.
//

import SwiftUI
import AVFoundation

struct MusicPlayerView: View {
    @Binding var isPlaying: Bool
    @Binding var currentMusic: Music?
    @Binding var audioPlayer: AVAudioPlayer?
    @Binding var currentPlaylist: [Music]
    @Binding var currentMusicIndex: Int
    @State private var currentTime: TimeInterval = 0
    @State private var repeatMode: RepeatMode = .none
    @State private var isShuffle: Bool = false
    
    private var duration: TimeInterval {
        audioPlayer?.duration ?? 0
    }
    
    enum RepeatMode {
        case none, one, all
    }
    
    var body: some View {
        VStack {
            if let music = currentMusic {
                HStack {
                    VStack(alignment: .leading) {
                        Text(music.title)
                            .font(.headline)
                        Text(music.zone)
                            .font(.subheadline)
                    }
                    Spacer()
                    HStack {
                        Button(action: {
                            previousTrack()
                        }) {
                            Image(systemName: "backward.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                        }
                        Button(action: {
                            togglePlayPause()
                        }) {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .resizable()
                                .frame(width: 44, height: 44)
                                .foregroundColor(.blue)
                        }
                        Button(action: {
                            nextTrack()
                        }) {
                            Image(systemName: "forward.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
                
                // Progress bar and time
                VStack {
                    Slider(value: $currentTime, in: 0...duration, onEditingChanged: sliderEditingChanged)
                        .accentColor(.blue)
                    HStack {
                        Text(formatTime(currentTime))
                            .font(.caption)
                        Spacer()
                        Text(formatTime(duration))
                            .font(.caption)
                    }
                }
                .padding()
                
                // Repeat and Shuffle buttons
                HStack {
                    Button(action: {
                        toggleRepeatMode()
                    }) {
                        Image(systemName: repeatMode == .one ? "repeat.1" : repeatMode == .all ? "repeat" : "repeat")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(repeatMode != .none ? .blue : .gray)
                    }
                    Spacer()
                    Button(action: {
                        isShuffle.toggle()
                    }) {
                        Image(systemName: "shuffle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(isShuffle ? .blue : .gray)
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
        .onReceive(timer) { _ in
            guard let player = audioPlayer, player.isPlaying else { return }
            currentTime = player.currentTime
        }
    }
    
    func togglePlayPause() {
        if isPlaying {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
        isPlaying.toggle()
    }
    
    func nextTrack() {
        if isShuffle {
            currentMusicIndex = Int.random(in: 0..<currentPlaylist.count)
        } else {
            if currentMusicIndex < currentPlaylist.count - 1 {
                currentMusicIndex += 1
            } else if repeatMode == .all {
                currentMusicIndex = 0
            } else {
                return
            }
        }
        playCurrentTrack()
    }
    
    func previousTrack() {
        if currentMusicIndex > 0 {
            currentMusicIndex -= 1
            playCurrentTrack()
        } else if repeatMode == .all {
            currentMusicIndex = currentPlaylist.count - 1
            playCurrentTrack()
        }
    }
    
    func playCurrentTrack() {
        let music = currentPlaylist[currentMusicIndex]
        if let url = Bundle.main.url(forResource: music.filename, withExtension: nil) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.delegate = AVDelegate(onFinish: {
                    if self.repeatMode == .one {
                        self.playCurrentTrack()
                    } else {
                        self.nextTrack()
                    }
                })
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
    
    func toggleRepeatMode() {
        switch repeatMode {
        case .none:
            repeatMode = .all
        case .all:
            repeatMode = .one
        case .one:
            repeatMode = .none
        }
    }
    
    private func sliderEditingChanged(editingStarted: Bool) {
        if !editingStarted {
            audioPlayer?.currentTime = currentTime
            if isPlaying {
                audioPlayer?.play()
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
}
