//
//  CalculateResultWorker.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//
import Dependencies
import Foundation

actor CalculateResultWorker: Worker {
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

        let selectionAction = previousItemState.isSelected ? ActionResult.unselectAWord : ActionResult.selectAWord

        return [selectionAction]
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
