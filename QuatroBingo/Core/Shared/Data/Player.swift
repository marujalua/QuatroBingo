//
//  Player.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//
import Foundation

struct Player: Codable, Equatable {
    let id: String
    let emoji: String
    let name: String
    var score: Int
}
