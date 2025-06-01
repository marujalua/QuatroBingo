//
//  DetailHeader.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 01/06/25.
//

import SwiftUI

struct DetailHeader: View {
    let title: String
    let description: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.black)

            Text(description)
                .font(.title3)
        }
    }
}

#Preview {
    DetailHeader(title: "title", description: "description")
}
