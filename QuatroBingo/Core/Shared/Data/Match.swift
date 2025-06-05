//
//  Match.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//
import FirebaseCore
import Foundation

struct Match: Codable, Equatable {
    enum Status: String, Codable, Equatable {
        case created, running, finished
    }

    struct Log: Codable, Equatable {
        let value: String
        let time: Timestamp
    }

    var status: Status
    let name: String
    var players: [String: Player]
    var logs: [Log]
}
