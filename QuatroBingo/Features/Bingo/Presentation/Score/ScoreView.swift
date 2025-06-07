//
//  ScoreView.swift
//  QuatroBingo
//
//  Created by Marcos Chevis on 07/06/25.
//

import SwiftUI
import ComposableArchitecture

struct ScoreView: View {
    @Bindable var store: StoreOf<ScoreFeature>
    
    var score: [ViewData.ScoreItem] {
        ScoreListAdapter.adapt(adapt: store.players)
    }
    var body: some View {
        VStack(spacing: -16) {
            Image(.score)
                .resizable()
                .aspectRatio(contentMode: .fit)
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(score) { item in
                        switch item {
                        case .divider:
                            Divider()
                                .overlay(Color.accentColor)
                        case .score(let scoreItem):
                            HStack {
                                Group {
                                    Text("\(scoreItem.place) \(scoreItem.emoji) \(scoreItem.name)")
                                    Spacer()
                                    Text("\(scoreItem.score)")
                                        
                                }
                                .monospacedDigit()
                                .font(.title2)
                                .fontWeight(.bold)
                                .fontDesign(.rounded)
                                .foregroundStyle(scoreItem.isHighlighted ? Color.accentColor : Color.accentColor.opacity(0.5))
                            }
                        }
                    }
                    Spacer()
                }
                .padding(32)

            }
            .background(.background)
            .clipShape(UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: 20,
                    topTrailing: 20
                )
            ))
            .shadow(color: .black, radius: 20)
        }
        .ignoresSafeArea(.all, edges: [.bottom, .top])
    }
}

extension ScoreView {
    struct ViewData {
        let scoreboard: [ScoreItem]
        
        enum ScoreItem: Identifiable {
            var id: String {
                switch self {
                case .divider(let id):
                    return id
                case .score(let score):
                    return score.id
                }
            }
            
            case divider(String)
            case score(PlayerScore)
        }
        
        struct PlayerScore: Identifiable {
            var id: String
            let emoji: String
            let name: String
            let score: String
            let isHighlighted: Bool
            let place: String
        }
    }
}
