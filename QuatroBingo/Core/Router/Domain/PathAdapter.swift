//
//  PathAdapter.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 07/06/25.
//
import Foundation
import ComposableArchitecture

protocol PathAdapter {
    func adapt(url: URL) -> RouterFeature.Path.State?
}

struct PathAdapterImpl: PathAdapter {
    func adapt(url: URL) -> RouterFeature.Path.State? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        guard
            let scheme = components?.scheme,
            let host = components?.host,
            scheme == "umbingo"
        else { return nil }

        switch host {
        case "enter-match":
            guard let params = components?.queryItems,
                  let bingoParam = params.first(where: { $0.name == "bingo" }),
                  let bingo = bingoParam.value
            else { return nil }

            if let matchParam = params.first(where: {$0.name == "match"}), let match = matchParam.value {
                return .detail(DetailFeature.State(id: bingo, stepState: .init(roomId: match, stepStack: [.name])))
            } else {
                return .detail(DetailFeature.State(id: bingo))
            }
        default:
            return nil
        }
    }
}

extension DependencyValues {
    var pathAdapter: PathAdapter {
        PathAdapterImpl()
    }
}
