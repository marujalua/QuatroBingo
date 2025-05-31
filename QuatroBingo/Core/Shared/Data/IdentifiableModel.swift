//
//  IdentifiableModel.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

struct IdentifiableModel<T: Decodable & Equatable>: Identifiable, Equatable {
    let id: String
    let model: T
}
