//
//  RotationExplainer.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 07/06/25.
//

import SwiftUI

struct RotationExplainer: View {
    @State var isVisible: Bool = true

    var body: some View {
        Button {
            isVisible = true
        } label: {
            Label("Explicar rotação", systemImage: "rectangle.portrait.rotate")
                .font(.title2.bold())
        }
        .buttonBorderShape(.circle)
        .buttonStyle(.borderedProminent)
        .sheet(isPresented: $isVisible) {
            NavigationStack {
                List {
                    Label(
                        "Rotacione a tela de jogo para ver a sua cartela",
                        systemImage: "rectangle.portrait.rotate"
                    )
                    Label(
                        "Na posição vertical temos a tela de pontuação.",
                        systemImage: "1.lane"
                    )
                    Label(
                        """
                        Na tela horizontal com a notch para esquerda temos o score.
                        """,
                        systemImage: "2.lane"
                    )
                    Label(
                        """
                        Na tela horizontal com a notch para direita temos a opção de compartilhar
                        """,
                        systemImage: "3.lane"
                    )
                }
                .preferredColorScheme(.light)
                .navigationTitle("Tutorial")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            isVisible = false
                        } label: {
                            Label("Fechar", systemImage: "xmark")
                        }
                        .buttonBorderShape(.circle)
                        .buttonStyle(.bordered)
                        .tint(.accent)
                    }
                })
            }

            .presentationDetents([.medium])
        }
    }
}

#Preview {
    RotationExplainer()
        .animatedBackground()
}
