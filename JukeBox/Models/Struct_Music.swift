//
//  Struct_Music.swift
//  JukeBox
//
//  Created by Maëva Bouvard on 14/06/2024.
//
import SwiftUI
import Foundation

struct Music: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let zone: String
    let composer: String
    let description: String
    let filename: String
}
