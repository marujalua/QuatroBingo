//
//  DetailFeature.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import ComposableArchitecture

@Reducer
struct DetailFeature {
    @Dependency(DetailInteractorKey.self) private var interactor

    @ObservableState
    struct State: Equatable {
        let id: String
        var status: Status = .loading
        var bingo: IdentifiableModel<Bingo>? = nil
        var stepState = StepperFeature.State()
    }

    enum Action {
        case stepChanged(StepperFeature.Action)
        case enterMatch
        case goToMatch(bingo: String, match: String, player: String)
        case retrieveBingo
        case storeBingo(IdentifiableModel<Bingo>)
        case enterMatchError
        case retrieveBingoError
    }

    var body: some ReducerOf<Self> {
        Scope(state: \State.stepState, action: \.stepChanged) {
            StepperFeature()
        }

        Reduce { state, action in
            switch action {
            case .enterMatch:
                guard !state.stepState.nickname.isEmpty, !state.stepState.roomId.isEmpty, let bingo = state.bingo else { return .none }
                return .run { [state, bingo] send in
                    let playerId = try await interactor.enterMatch(
                        roomId: state.stepState.roomId,
                        bingo: bingo.id,
                        playerName: state.stepState.nickname,
                        bingoName: bingo.model.name
                    )
                    await send(.goToMatch(bingo: bingo.id, match: state.stepState.roomId, player: playerId))
                } catch: { _, send in
                    await send(.enterMatchError)
                }
            case .retrieveBingo:
                state.status = .loading
                return .run { [state] send in
                    let bingo = try await interactor.getBingo(for: state.id)
                    await send(.storeBingo(bingo))
                } catch: { _, send in
                    await send(.retrieveBingoError)
                }
            case let .storeBingo(bingo):
                state.status = .success
                state.bingo = bingo
                return .none
            case .retrieveBingoError:
                state.status = .failure
                return .none
            default:
                return .none
            }
        }
    }
}

