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
                        HStack(alignment: .center) {
                            Text(log.value)
                                .foregroundStyle(Color.black)
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
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

