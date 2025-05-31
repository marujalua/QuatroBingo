//
//  Worker.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//

protocol Worker: Actor {
    associatedtype Input
    associatedtype Output

    func execute(with: Input) async throws -> Output
}
