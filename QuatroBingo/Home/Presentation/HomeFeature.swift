//
//  HomeFeature.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import ComposableArchitecture
import Dependencies

@Reducer
struct HomeFeature {
    @Dependency(HomeInteractorKey.self) private var interactor

    @ObservableState
    struct State: Equatable {
        var status: Status = .loading
        var bingos: [BingoViewModel] = []
    }

    enum Action {
        case requestBingo
        case loadBingos([BingoViewModel])
        case requestError
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .requestBingo:
                state.status = .loading
                return .run { send in
                    do {
                        let bingos = try await interactor.fetchAvailableBingo()
                        await send(.loadBingos(bingos))
                    } catch {
                        await send(.requestError)
                    }
                }
            case .loadBingos(let bingos):
                state.status = .success
                state.bingos = bingos
                return .none
            case .requestError:
                state.status = .failure
                return .none
            }
        }
    }
}
