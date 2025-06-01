//
//  UpdateLogWorker.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//
import Dependencies

actor UpdateLogWorker: Worker {
    @Dependency(\.date) private var currentDate

    struct Input {
        let player: Player
        let results: [ActionResult]
    }

    typealias Output = [Match.Log]

    func execute(with input: Input) async throws -> [Match.Log] {
        input.results.map { result in
            adapt(result, player: input.player)
        }
    }

    private func adapt(_ input: ActionResult, player: Player) -> Match.Log {
        let value: String = switch input {
        case .selectAWord:
            "marcou uma palavra."
        case .unselectAWord:
            "desmarcou uma palavra"
        case .finishedARow:
            "terminou uma linha"
        case .finishedAColumn:
            "terminou uma coluna"
        case .finishedADiagonal:
            "terminou uma diagonal"
        case .calledBingo:
            "bingou"
        }

        return Match.Log(value: "\(player.name) \(value)", time: currentDate())
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
