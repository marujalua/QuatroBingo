//
//  DetailInteractor.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//
import Dependencies

protocol DetailInteractor: Actor {
    func getBingo(for id: String) async throws -> IdentifiableModel<Bingo>

    func enterMatch(
        roomId: String,
        bingo: String,
        playerName: String,
        bingoName: String
    ) async throws -> String
}

actor DetailInteractorImpl: DetailInteractor {
    @Dependency(DetailRepositoryKey.self) private var repository
    @Dependency(\.uuid) private var uuid

    func enterMatch(
        roomId: String,
        bingo: String,
        playerName: String,
        bingoName: String
    ) async throws -> String {
        let match = try? await repository.retrieveMatch(for: roomId, at: bingo)
        let player = Player(id: uuid().uuidString, name: playerName, score: 0)

        if match != nil {
            try await repository.insertPlayer(player, into: playerName, at: bingo)
        } else {
            let match = Match(
                status: .created,
                name: bingoName,
                players: [player],
                logs: []
            )
            try await repository.createMatch(match, for: roomId, at: bingo)
        }

        return player.id
    }

    func getBingo(for id: String) async throws -> IdentifiableModel<Bingo> {
        let bingo = try await repository.retrieveBingo(for: id)
        let words = Array(bingo.model.words.prefix(9))

        return IdentifiableModel(id: bingo.id, model: Bingo(name: bingo.model.name, words: words))
    }
}

enum DetailInteractorKey: DependencyKey {
    static var liveValue: DetailInteractor = DetailInteractorImpl()
}
