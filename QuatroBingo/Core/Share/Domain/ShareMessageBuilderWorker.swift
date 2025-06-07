//
//  ShareMessageBuilderWorker.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 07/06/25.
//
import Foundation
import Dependencies

actor ShareMessageBuilderWorker: Worker {
    typealias Input = IDs
    typealias Output = String

    @Dependency(\.shareUrlWorker) private var urlBuilderWorker

    func execute(with input: IDs) async throws -> String {
        let url = try await urlBuilderWorker.execute(with: input)

        return """
        ✌️ venha bingar você também!!
        
        acesse a url abaixo para para entrar na partida 😚
        
        \(url)
        """
    }
}

extension DependencyValues {
    var shareMessageWorker: ShareMessageBuilderWorker {
        ShareMessageBuilderWorker()
    }
}
