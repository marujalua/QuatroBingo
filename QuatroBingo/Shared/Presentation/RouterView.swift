//
//  RouterView.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import SwiftUI
import Observation

enum Route: Hashable {
    case detail(bingoId: String)
}

@Observable
@MainActor
final class Router {
    fileprivate var path: NavigationPath = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}

struct RouterView<Root: View>: View {
    @State private var router: Router = Router()
    @ViewBuilder let root: () -> Root

    init(root: @escaping () -> Root) {
        self.root = root
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            root()
                .navigationDestination(for: Route.self) { route in
                    routeBuilder(for: route)
                }
                .environment(router)
        }
    }

    @ViewBuilder func routeBuilder(for route: Route) -> some View {
        switch route {
        case .detail(let bingoId):
            Text(bingoId)
        }
    }
}
