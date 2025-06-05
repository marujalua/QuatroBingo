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
    func updateMatch(match: Match, table: BingoTable, actionPoint: CGPoint, ids: IDs) async throws
}

actor BingoInteractorImpl: BingoInteractor {
    @Dependency(\.bingoRepository) private var bingoRepository
    @Dependency(\.calculateScore) private var calculateScore
    @Dependency(\.calculateResult) private var calculateResult
    @Dependency(\.updateLog) private var updateLog

    func retrieveBingo(bingo: String) async throws -> BingoTable {
        let bingo = try await bingoRepository.retrieveBingo(for: bingo)
        let words = bingo.words.shuffled().prefix(25)

        guard let table = BingoTable(words: Array(words)) else { throw NSError() }
        return table
    }

    func watchMatch(bingo: String, match: String) async -> any AsyncSequence<Match, any Error> {
        await bingoRepository.watchMatch(bingo: bingo, match: match)
    }

    func updateMatch(
        match: Match,
        table: BingoTable,
        actionPoint: CGPoint,
        ids: IDs
    ) async throws {
        async let newScore = calculateScore.execute(with: table)
        async let newLogs = calculateResult.execute(with: .init(table: table, move: actionPoint))

        let (newScoreLoaded, newLogsLoaded) = await (try newScore, try newLogs)

        guard let player = match.players[ids.player] else { throw NSError() }

        let logsToAppended = try await updateLog.execute(with: .init(player: player, results: newLogsLoaded))

        var newMatch = match
        newMatch.players[ids.player]?.score = newScoreLoaded.total
        newMatch.logs.append(contentsOf: logsToAppended)
        newMatch.logs.sort { lhs, rhs in
            lhs.time.seconds > rhs.time.seconds
        }

        try await bingoRepository.updateMatch(ids: ids, match: newMatch)
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
