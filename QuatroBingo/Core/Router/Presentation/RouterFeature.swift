//
//  RouterFeature.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//
import Foundation
import ComposableArchitecture

@Reducer
struct RouterFeature {
    @Dependency(\.pathAdapter) private var pathAdapter
    @Reducer
    enum Path {
        case detail(DetailFeature)
        case bingo(BingoFeature)
    }

    @ObservableState
    struct State {
        var path = StackState<Path.State>()
    }

    enum Action {
        case detail(id: String)
        case url(URL)
        case path(StackActionOf<Path>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .url(url):
                guard let path = pathAdapter.adapt(url: url) else { return .none }
                state.path.append(path)
                return .none
            case let .detail(id):
                state.path.append(.detail(DetailFeature.State(id: id)))
                return .none
            case let .path(.element(_, action: .detail(.goToMatch(bingo, match, player)))):
                state.path.append(.bingo(.init(ids: .init(bingo: bingo, player: player, match: match))))
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

extension RouterFeature.Path.State: Equatable {}
