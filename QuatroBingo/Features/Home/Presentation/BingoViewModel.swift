//
//  BingoViewModel.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

struct BingoViewModel: Equatable, Identifiable {
    let id: String
    let name: String
    let wordsPreview: [String]
    let wordCount: Int
}
