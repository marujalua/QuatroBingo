//
//  ShareUrlBuilderWorker.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 07/06/25.
//
import Foundation
import Dependencies

actor ShareEnterMatchUrlBuilderWorker: Worker {
    typealias Input = IDs
    typealias Output = URL

    func execute(with input: IDs) async throws -> Output {
        var components = URLComponents()
        components.scheme = "umbingo"
        components.host = "enter-match"

        var queryItems: [URLQueryItem] = []

        if !input.bingo.isEmpty {
            queryItems.append(URLQueryItem(name: "bingo", value: input.bingo))
        }

        if !input.match.isEmpty {
            queryItems.append(URLQueryItem(name: "match", value: input.match))
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        return url
    }
}

extension DependencyValues {
    var shareUrlWorker: ShareEnterMatchUrlBuilderWorker {
        ShareEnterMatchUrlBuilderWorker()
    }
}
