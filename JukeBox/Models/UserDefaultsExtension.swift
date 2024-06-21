//
//  UserDefaultsExtension.swift
//  JukeBox
//
//  Created by Maëva Bouvard on 20/06/2024.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let selectedPlaylist = "selectedPlaylist"
        static let currentMusicIndex = "currentMusicIndex"
    }

    var selectedPlaylist: [String] {
        get {
            return array(forKey: Keys.selectedPlaylist) as? [String] ?? []
        }
        set {
            set(newValue, forKey: Keys.selectedPlaylist)
        }
    }
    
    var currentMusicIndex: Int {
        get {
            return integer(forKey: Keys.currentMusicIndex)
        }
        set {
            set(newValue, forKey: Keys.currentMusicIndex)
        }
    }
}
