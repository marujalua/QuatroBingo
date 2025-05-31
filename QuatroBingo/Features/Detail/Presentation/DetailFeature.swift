//
//  DetailFeature.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct DetailFeature {
    @Dependency(DetailInteractorKey.self) private var interactor

    @ObservableState
    struct State: Equatable {
        let id: String
        var status: Status = .loading
        var bingo: IdentifiableModel<Bingo>? = nil
        var stepState = StepperFeature.State()
        var enterMatchErrorDisplayed = false
    }

    enum Action {
        case stepChanged(StepperFeature.Action)
        case enterMatch
        case goToMatch(bingo: String, match: String, player: String)
        case retrieveBingo
        case storeBingo(IdentifiableModel<Bingo>)
        case retrieveBingoError
        case enterMatchErrorDisplayed(Bool)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \State.stepState, action: \.stepChanged) {
            StepperFeature()
        }

        Reduce { state, action in
            switch action {
            case .enterMatch:
                state.enterMatchErrorDisplayed = false
                return enterMatchEffect(&state)
            case .retrieveBingo:
                state.status = .loading
                return retrieveBingoEffect(&state)
            case let .storeBingo(bingo):
                state.status = .success
                state.bingo = bingo
                return .none
            case .retrieveBingoError:
                state.status = .failure
                return .none
            case let .enterMatchErrorDisplayed(value):
                state.enterMatchErrorDisplayed = value
                return .none
            default:
                return .none
            }
        }
    }

    private func enterMatchEffect(_ state: inout State) -> EffectOf<Self> {
        guard
            !state.stepState.nickname.isEmpty,
            !state.stepState.roomId.isEmpty,
            let bingo = state.bingo
        else {
            return .none
        }

        return Effect.run { [state, bingo] send in
            let playerId = try await interactor.enterMatch(
                roomId: state.stepState.roomId,
                bingo: bingo.id,
                playerName: state.stepState.nickname,
                bingoName: bingo.model.name
            )
            await send(Action.goToMatch(bingo: bingo.id, match: state.stepState.roomId, player: playerId))
        } catch: { _, send in
            await send(Action.enterMatchErrorDisplayed(true))
        }
    }

    private func retrieveBingoEffect(_ state: inout State) -> EffectOf<Self> {
        Effect.run { [state] send in
            let bingo = try await interactor.getBingo(for: state.id)
            await send(.storeBingo(bingo))
        } catch: { _, send in
            await send(.retrieveBingoError)
        }
    }
}

