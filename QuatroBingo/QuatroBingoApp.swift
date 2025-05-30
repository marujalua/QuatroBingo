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
            RouterView {
                HomeView(store: Store(initialState: HomeFeature.State()) {
                    HomeFeature()
                  }
                )
            }
        }
    }
}
