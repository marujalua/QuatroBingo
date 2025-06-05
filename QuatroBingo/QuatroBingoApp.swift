//
//  QuatroBingoApp.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 29/05/25.
//
import Firebase
import SwiftUI
import ComposableArchitecture
@main
struct QuatroBingoApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            BingoView(
                store: Store(
                    initialState: BingoFeature.State(
                        ids: .init(bingo: "dm7Pmecx31VTkCKQcFA1", player: "F66F3F47-ED8F-4F23-97C0-65A6A492839A", match: "D9FA1AC0-2D6A-4EA0-8DDF-35E0050A5E33")
                    ),
                    reducer: BingoFeature.init
                )
            )
//            RouterView(
//                store: Store(initialState: RouterFeature.State(), reducer: {
//                    RouterFeature()
//                })
//            )
        }
    }
}
