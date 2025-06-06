//
//  LogView.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//

import SwiftUI
import ComposableArchitecture

struct LogView: View {
    @State var store: StoreOf<LogFeature>

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(Array(store.logs.enumerated()), id: \.offset) { _, log in
                        LogCell(log: log)
                    }
                }
            }
            Text(store.name)
                .font(.system(size: 36))
                .fontWeight(.black)
                .foregroundStyle(.white)
        }
    }
}

