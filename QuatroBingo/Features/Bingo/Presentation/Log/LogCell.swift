//
//  LogCell.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//

import SwiftUI

struct LogCell: View {
    let log: Match.Log

    var body: some View {
        HStack(alignment: .center) {
            Text(log.value)
                .foregroundStyle(Color.black)
                .font(.system(size: 12))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Material.thin)
        .preferredColorScheme(.light)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
