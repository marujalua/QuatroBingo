//
//  CalculateScoreWorker.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//

actor CalculateScoreWorkerImpl: Worker {
    typealias Input = BingoTable
    typealias Output = Int

    func execute(with: BingoTable) async throws -> Int {
        0
    }
}

