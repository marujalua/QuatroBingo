//
//  BingoFeature.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//

import ComposableArchitecture
import UIKit

@Reducer
struct BingoFeature {
    @Dependency(\.bingoInteractor) private var bingoInteractor

    @ObservableState
    struct State: Equatable {
        var shareIds: ShareFeature.State
        var board = BoardFeature.State()
        var log = LogFeature.State(name: "", logs: [])
        var score = ScoreFeature.State(players: [:])
        var status: Status = .loading
        var orientation: UIDeviceOrientation = UIDevice.current.orientation

        init(ids: IDs) {
            self.shareIds = .init(ids: ids)
        }
    }

    enum Action {
        case board(BoardFeature.Action)
        case log(LogFeature.Action)
        case score(ScoreFeature.Action)
        case share(ShareFeature.Action)
        case updateStatus(Status)
        case onAppear
        case listenError
        case updateOrientation(UIDeviceOrientation)
    }

    enum CancelID { case listener }

    var body: some ReducerOf<Self> {
        Scope(state: \.board, action: \.board) {
            BoardFeature()
        }

        Scope(state: \.log, action: \.log) {
            LogFeature()
        }

        Scope(state: \.score, action: \.score) {
            ScoreFeature()
        }

        Scope(state: \.shareIds, action: \.share) {
            ShareFeature()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                state.status = Status.loading
                return Effect.concatenate(
                    requestBingoEffect(state: &state),
                    listenToMatchEffect(state: &state)
                ).merge(with: updateOrientationEffect(state: &state))
            case let .updateStatus(status):
                state.status = status
                return .none
            case .listenError:
                state.status = .failure
                return .cancel(id: CancelID.listener)
            case let .board(.updateDataDelegate(table, x, y)):
                guard let table else { return .none }
                return updateMatchEffect(
                    match: Match(status: .running, name: state.log.name, players: state.score.players, logs: state.log.logs),
                    table: table,
                    point: CGPoint(x: x, y: y),
                    ids: state.shareIds.ids
                )
            case let .updateOrientation(orientation):
                state.orientation = orientation
                return .none
                
            default:
                return .none
            }
        }
    }

    private func listenToMatchEffect(state: inout State) -> EffectOf<BingoFeature> {
        return .run {[state] send in
            let sequence = await bingoInteractor.watchMatch(bingo: state.shareIds.ids.bingo, match: state.shareIds.ids.match)

            for try await match in sequence {
                await send(.log(.updateLogs(match.logs)))
                await send(.score(.updatePlayers(match.players)))
            }
        } catch: { _, send in
            await send(.listenError)
        }.cancellable(id: CancelID.listener, cancelInFlight: true)
    }

    private func requestBingoEffect(state: inout State) -> EffectOf<BingoFeature> {
        return .run {[state] send in
            let table = try await bingoInteractor.retrieveBingo(bingo: state.shareIds.ids.bingo)
            await send(.board(.loadTable(table)))
            await send(.updateStatus(.success))
        } catch: {_ , send in
            await send(.updateStatus(.failure))
        }
    }

    private func updateMatchEffect(match: Match, table: BingoTable, point: CGPoint, ids: IDs) -> EffectOf<BingoFeature> {
        return .run {[match, table, point, ids] send in
            try await bingoInteractor.updateMatch(
                match: match,
                table: table,
                actionPoint: point,
                ids: ids
            )
        }
    }
    
    private func updateOrientationEffect(state: inout State) -> EffectOf<BingoFeature> {
        return .publisher {
            NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification).compactMap { _ in
                UIDevice.current.orientation
            }.map { orientation in
                Action.updateOrientation(orientation)
            }
        }
    }
}
