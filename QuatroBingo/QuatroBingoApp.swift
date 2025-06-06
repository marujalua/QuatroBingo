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
            RouterView(
                store: Store(initialState: RouterFeature.State(), reducer: {
                    RouterFeature()
                })
            )
        }
    }
}
