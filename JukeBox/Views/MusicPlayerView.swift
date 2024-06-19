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
    var audioPlayer: AVAudioPlayer?

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
                    Button(action: {
                        togglePlayPause()
                    }) {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }

    func togglePlayPause() {
        if isPlaying {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
        isPlaying.toggle()
    }
}
