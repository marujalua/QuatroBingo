//
//  UpdateLogWorker.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//
import Dependencies

actor UpdateLogWorker: Worker {
    struct Input {
        let player: Player
        let results: [ActionResult]
    }

    typealias Output = [Match.Log]

    func execute(with input: Input) async throws -> [Match.Log] {
        []
    }
}

private struct UpdateLogWorkerKey: DependencyKey {
    static var liveValue: UpdateLogWorker = UpdateLogWorker()
}

extension DependencyValues {
    var updateLog: UpdateLogWorker {
        get { self[UpdateLogWorkerKey.self] }
        set { self[UpdateLogWorkerKey.self] = newValue }
      }
}
