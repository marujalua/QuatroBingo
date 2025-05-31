//
//  StatusView.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import SwiftUI

struct StatusView<Success: View, Failure: View>: View {
    let status: Status
    @ViewBuilder let success: () -> Success
    @ViewBuilder let failure: () -> Failure

    var body: some View {
        switch status {
        case .loading:
            ProgressView()
        case .failure:
            failure()
        case .success:
            success()
        }
    }
}
