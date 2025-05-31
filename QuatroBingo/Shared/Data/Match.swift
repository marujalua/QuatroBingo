//
//  Match.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//
import Foundation

struct Match: Codable {
    enum Status: String, Codable {
        case created, running, finished
    }

    struct Log: Codable {
        let value: String
        let time: Date
    }

    var status: Status
    let name: String
    var players: [Player]
    var logs: [Log]
}
