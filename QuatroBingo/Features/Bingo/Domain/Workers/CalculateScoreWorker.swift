//
//  CalculateScoreWorker.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//
import Dependencies

actor CalculateScoreWorker: Worker {
    typealias Input = BingoTable
    struct Output {
        let allWords: Int
        let columns: Int
        let rows: Int
        let mainDiagonal: Int
        let inverseDiagonal: Int

        var total: Int {
            allWords + columns + rows + mainDiagonal + inverseDiagonal
        }
    }


    func execute(with input: BingoTable) async throws -> Output {
        let allWordsPoints = input.table.flatMap { $0.map(\.isSelected).filter { $0 } }.count
        let allColumnsPoints = calculateMultipleLists(input.allColumns, tableSize: input.tableSize)
        let allRowPoints = calculateMultipleLists(input.allRows, tableSize: input.tableSize)
        let mainDiagonal = input.mainDiagonal.map(\.isSelected).allSatisfy { $0 } ? 7 : 0
        let inverseDiagonal = input.inverseDiagonal.map(\.isSelected).allSatisfy { $0 } ? 7 : 0

        return Output(
            allWords: allWordsPoints,
            columns: allColumnsPoints,
            rows: allRowPoints,
            mainDiagonal: mainDiagonal,
            inverseDiagonal: inverseDiagonal
        )
    }

    private func calculateMultipleLists(_ input: [[BingoTable.Word]]?, tableSize: Int) -> Int {
        guard let input else { return 0 }

        return input.map { column in
            column.reduce(0) { result, word in
                let value = word.isSelected ? 1 : 0
                return result + value
            }
        }.reduce(0, { partialResult, current in
            if current == tableSize {
                return partialResult + 5
            }
            return partialResult
        })
    }
}

private struct CalculateScoreWorkerKey: DependencyKey {
    static var liveValue: CalculateScoreWorker = CalculateScoreWorker()
}

extension DependencyValues {
    var calculateScore: CalculateScoreWorker {
        get { self[CalculateScoreWorkerKey.self] }
        set { self[CalculateScoreWorkerKey.self] = newValue }
      }
}
