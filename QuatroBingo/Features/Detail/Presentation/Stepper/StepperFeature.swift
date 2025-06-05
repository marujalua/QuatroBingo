//
//  StepperFeature.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import ComposableArchitecture

@Reducer
struct StepperFeature {
    @Dependency(\.uuid) private var uuid

    @ObservableState
    struct State: Equatable {
        var nickname: String = ""
        var emoji: String = Emoji.randomEmoji()
        var roomId: String = ""
        var stepStack: [Step] = [.select]

        var step: Step {
            stepStack.last ?? .select
        }

        enum Step {
            case name, create, search, select
        }
    }

    enum Action {
        case valueDidChange(String)
        case roomIdDidChange(String)
        case createMatch
        case searchMatch
        case confirmMatch
        case changeEmoji
        case back
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .valueDidChange(let value):
                state.nickname = value
            case .roomIdDidChange(let value):
                state.roomId = value
            case .createMatch:
                state.roomId = uuid().uuidString
                state.stepStack.append(.create)
            case .changeEmoji:
                state.emoji = Emoji.randomEmoji()
            case .searchMatch:
                state.stepStack.append(.search)
            case .confirmMatch:
                state.stepStack.append(.name)
            case .back:
                state.roomId = ""
                state.nickname = ""
                if state.stepStack.count > 1 {
                    _ = state.stepStack.popLast()
                }
            }
            return .none
        }
    }
}
