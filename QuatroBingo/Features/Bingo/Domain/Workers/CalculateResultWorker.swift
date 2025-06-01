//
//  CalculateResultWorker.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//
import Dependencies
import Foundation

actor CalculateResultWorker: Worker {
    @Dependency(\.calculateScore) private var calculateScoreWorker

    struct Input {
        let table: BingoTable
        let move: CGPoint
    }

    typealias Output = [ActionResult]

    func execute(with input: Input) async throws -> [ActionResult] {
        var previousTable = input.table

        guard var previousItemState = previousTable[Int(input.move.x), Int(input.move.y)] else { throw NSError() }
        previousItemState.isSelected.toggle()
        previousTable[Int(input.move.x), Int(input.move.y)] = previousItemState

        let previousTableConstant = previousTable

        let selectionAction = previousItemState.isSelected ? ActionResult.unselectAWord : ActionResult.selectAWord

        async let current = calculateScoreWorker.execute(with: input.table)
        async let previous = calculateScoreWorker.execute(with: previousTableConstant)

        let score: (current: CalculateScoreWorker.Output, previous: CalculateScoreWorker.Output) = try await (current, previous)

        var results: [ActionResult] = [selectionAction]

        if score.current.columns > score.previous.columns {
            results.append(.finishedAColumn)
        }

        if score.current.rows > score.previous.rows {
            results.append(.finishedARow)
        }

        if score.current.mainDiagonal > score.previous.mainDiagonal {
            results.append(.finishedADiagonal)
        }

        if score.current.inverseDiagonal > score.previous.inverseDiagonal {
            results.append(.finishedADiagonal)
        }

        return results
    }
}

private struct CalculateResultWorkerKey: DependencyKey {
    static var liveValue: CalculateResultWorker = CalculateResultWorker()
}

extension DependencyValues {
    var calculateResult: CalculateResultWorker {
        get { self[CalculateResultWorkerKey.self] }
        set { self[CalculateResultWorkerKey.self] = newValue }
      }
}
