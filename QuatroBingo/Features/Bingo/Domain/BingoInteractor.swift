//
//  BingoInteractor.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//
import Dependencies
import UIKit

protocol BingoInteractor: Actor {
    func retrieveBingo(bingo: String) async throws -> BingoTable
    func watchMatch(bingo: String, match: String) async -> any AsyncSequence<Match, Error>
    func updateMatch(match: Match, table: BingoTable, actionPoint: CGPoint) async throws
}

actor BingoInteractorImpl: BingoInteractor {
    @Dependency(\.bingoRepository) private var bingoRepository

    func retrieveBingo(bingo: String) async throws -> BingoTable {
        let bingo = try await bingoRepository.retrieveBingo(for: bingo)
        let words = bingo.words.shuffled().prefix(25)

        guard let table = BingoTable(words: Array(words)) else { throw NSError() }
        return table
    }

    func watchMatch(bingo: String, match: String) async -> any AsyncSequence<Match, any Error> {
        await bingoRepository.watchMatch(bingo: bingo, match: match)
    }

    func updateMatch(match: Match, table: BingoTable, actionPoint: CGPoint) async throws {
        
    }
}

private struct BingoInteractorKey: DependencyKey {
    static var liveValue: BingoInteractor = BingoInteractorImpl()
}

extension DependencyValues {
    var bingoInteractor: BingoInteractor {
        get { self[BingoInteractorKey.self] }
        set { self[BingoInteractorKey.self] = newValue }
      }
}
