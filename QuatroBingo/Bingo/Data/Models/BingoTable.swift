//
//  BingoTable.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//

struct BingoTable: Equatable {
    private(set) var table: [[Word]]
    let tableSize: Int

    init?(words: [String]) {
        let (tableSize, isPerfectSqrt) = words.count.isPerfectSquare()
        guard isPerfectSqrt else { return nil }

        var table: [[Word]] = []

        for i in 0..<tableSize {
            let minRange = i * tableSize
            let maxRange = ((i + 1) * tableSize) - 1

            let range = words[minRange...maxRange]

            table.append(Array(range).map { Word(value: $0) })
        }
        self.tableSize = tableSize
        self.table = table
    }

    subscript(x: Int, y: Int) -> Word? {
        get {
            guard
                x < table.count,
                y < table.count
            else {
                return nil
            }

            return table[y][x]
        }

        set {
            guard
                x < table.count,
                y < table.count,
                let newValue
            else {
                return
            }

            table[y][x] = newValue
        }
    }

    subscript(rowAt y: Int) -> [Word]? {
        get {
            guard
                y < table.count
            else {
                return nil
            }

            return table[y]
        }
    }

    subscript(columnAt x: Int) -> [Word]? {
        guard
            x < table.count
        else {
            return nil
        }

        var column: [Word] = []

        for i in 0 ..< tableSize {
            column.append(table[i][x])
        }

        return column
    }

    var mainDiagonal: [Word] {
        var diagonal: [Word] = []
        for i in 0 ..< tableSize {
            diagonal.append(table[i][i])
        }
        return diagonal
    }

    var inverseDiagonal: [Word] {
        var diagonal: [Word] = []
        for i in 0 ..< tableSize {
            let inverse = (tableSize - 1) - i
            diagonal.append(table[inverse][i])
        }
        return diagonal
    }
}

extension BingoTable {
    struct Word: Equatable {
        let value: String
        var isSelected: Bool = false
    }
}
