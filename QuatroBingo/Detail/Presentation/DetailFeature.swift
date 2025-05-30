//
//  DetailFeature.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import ComposableArchitecture

@Reducer
struct DetailFeature {

    @ObservableState
    struct State: Equatable {
        let id: String
    }

    enum Action {
        case testingNav
    }
}
