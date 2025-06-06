//
//  DetailRepository.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import Dependencies
import FirebaseFirestore

protocol DetailRepository: Actor {
    func retrieveMatch(for id: String, at bingo: String) async throws -> Match
    func retrieveBingo(for id: String) async throws -> IdentifiableModel<Bingo>
    func createMatch(_ match: Match, for id: String, at bingo: String) async throws
    func insertPlayer(_ player: Player, into matchId: String, at bingo: String) async throws
}

actor DetailRepositoryImpl: DetailRepository {
    @Dependency(Firestore.self) private var firebase
    @Dependency(Firestore.Encoder.self) private var encoder
    @Dependency(Firestore.Decoder.self) private var decoder


    func retrieveMatch(for id: String, at bingo: String) async throws -> Match {
        let reference = try await matchReference(for: id, at: bingo)
            .getDocument()


        return try reference.data(as: Match.self, decoder: decoder)
    }

    func retrieveBingo(for id: String) async throws -> IdentifiableModel<Bingo> {
        let reference = try await firebase
            .collection(Constants.bingo)
            .document(id)
            .getDocument()

        return IdentifiableModel(id: reference.documentID, model: try reference.data(as: Bingo.self))
    }

    func createMatch(_ match: Match, for id: String, at bingo: String) async throws {
        try await matchReference(for: id, at: bingo)
            .setDataAsync(from: match, merge: false)
    }

    func insertPlayer(_ player: Player, into matchId: String, at bingo: String) async throws {
        var match = try await retrieveMatch(for: matchId, at: bingo)
        match.players[player.id] = player
        try await createMatch(match, for: matchId, at: bingo)
    }

    private func matchReference(for match: String, at bingo: String) -> DocumentReference {
        firebase
            .collection(Constants.bingo)
            .document(bingo)
            .collection(Constants.matches)
            .document(match)
    }

    enum Constants {
        static var bingo: String { "bingos" }
        static var matches: String { "matches" }
    }
}

enum DetailRepositoryKey: DependencyKey {
    static var liveValue: DetailRepository = DetailRepositoryImpl()
}
