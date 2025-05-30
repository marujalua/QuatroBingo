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
        case bingoTapped(id: String)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .requestBingo:
                state.status = .loading
                return .run(priority: .high) { send in
                    let bingos = try await interactor.fetchAvailableBingo()
                    await send(.loadBingos(bingos))
                } catch: { _, send in
                    await send(.requestError)
                }
            case .loadBingos(let bingos):
                state.status = .success
                state.bingos = bingos
                return .none
            case .requestError:
                state.status = .failure
                return .none
            default:
                return .none
            }
        }
    }
}
