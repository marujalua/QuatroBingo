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
                Image(.scoreForeground)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(AnimatedScoreBackgroundView())
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

struct AnimatedScoreBackgroundView: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            let timeInterval = timeline.date.timeIntervalSinceReferenceDate
            let scale = 1.25 + (0.55 * sin(timeInterval))
            let angle = Angle.degrees(sin(timeInterval / 2) * 10)

            Canvas { context, size in
                context.addFilter(.blur(radius: 5.5))
                
                let rect = CGRect(
                    origin: .zero,
                    size: CGSize(width: size.width * 3, height: size.height * 3)
                )
                
                let path = PurplePolygonShape().path(in: rect)
                
                context.translateBy(x: size.width / 2, y: size.height / 2)
                context.rotate(by: angle)
                context.scaleBy(x: scale, y: scale)
                context.translateBy(x: -rect.width / 2, y: -rect.height / 2)
                
                context.fill(path, with: .color(.purpleStar))
            }
            .background(Color.scoreBackground)
        }
    }
}


#Preview {
    ScoreView(
        store: Store(
            initialState: ScoreFeature.State(
                players: [
                    "1":.init(
                        id: "1",
                        emoji: "😍",
                        name: "Nathy",
                        score: 20
                    ),
                    "2":.init(
                        id: "2",
                        emoji: "😂",
                        name: "Chevis",
                        score: 21
                    ),
                    "3":.init(
                        id: "3",
                        emoji: "☺️",
                        name: "Paula",
                        score: 23
                    ),
                    "4":.init(
                        id: "4",
                        emoji: "😄",
                        name: "Karina",
                        score: 24
                    ),
                    "5":.init(
                        id: "5",
                        emoji: "🙃",
                        name: "Lua",
                        score: 29
                    )
                ]
                
            ),
            reducer: ScoreFeature.init
        )
    )
}


struct PurplePolygonShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height

        func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(x: x / 1401 * width, y: y / 1401 * height)
        }

        var path = Path()
        path.move(to: point(770.254, 0.867151))
        path.addLine(to: point(711.434, 645.242))
        path.addLine(to: point(905.381, 27.9386))
        path.addLine(to: point(721.98, 648.457))
        path.addLine(to: point(1032.63, 80.8519))
        path.addLine(to: point(731.696, 653.668))
        path.addLine(to: point(1147.11, 157.574))
        path.addLine(to: point(740.209, 660.674))
        path.addLine(to: point(1244.43, 255.155))
        path.addLine(to: point(747.191, 669.206))
        path.addLine(to: point(1320.83, 369.847))
        path.addLine(to: point(752.375, 678.936))
        path.addLine(to: point(1373.4, 497.241))
        path.addLine(to: point(755.561, 689.491))
        path.addLine(to: point(1400.1, 632.442))
        path.addLine(to: point(756.627, 700.464))
        path.addLine(to: point(1399.91, 770.254))
        path.addLine(to: point(755.531, 711.434))
        path.addLine(to: point(1372.83, 905.381))
        path.addLine(to: point(752.316, 721.98))
        path.addLine(to: point(1319.92, 1032.63))
        path.addLine(to: point(747.106, 731.696))
        path.addLine(to: point(1243.2, 1147.11))
        path.addLine(to: point(740.1, 740.209))
        path.addLine(to: point(1145.62, 1244.43))
        path.addLine(to: point(731.568, 747.191))
        path.addLine(to: point(1030.93, 1320.83))
        path.addLine(to: point(721.837, 752.375))
        path.addLine(to: point(903.532, 1373.4))
        path.addLine(to: point(711.283, 755.561))
        path.addLine(to: point(768.332, 1400.1))
        path.addLine(to: point(700.309, 756.627))
        path.addLine(to: point(630.52, 1399.91))
        path.addLine(to: point(689.339, 755.531))
        path.addLine(to: point(495.393, 1372.83))
        path.addLine(to: point(678.793, 752.316))
        path.addLine(to: point(368.143, 1319.92))
        path.addLine(to: point(669.077, 747.106))
        path.addLine(to: point(253.662, 1243.2))
        path.addLine(to: point(660.564, 740.1))
        path.addLine(to: point(156.348, 1145.62))
        path.addLine(to: point(653.582, 731.568))
        path.addLine(to: point(79.9413, 1030.93))
        path.addLine(to: point(648.398, 721.837))
        path.addLine(to: point(27.3779, 903.532))
        path.addLine(to: point(645.212, 711.283))
        path.addLine(to: point(0.677767, 768.331))
        path.addLine(to: point(644.147, 700.309))
        path.addLine(to: point(0.867108, 630.52))
        path.addLine(to: point(645.242, 689.339))
        path.addLine(to: point(27.9386, 495.393))
        path.addLine(to: point(648.457, 678.793))
        path.addLine(to: point(80.8519, 368.143))
        path.addLine(to: point(653.668, 669.077))
        path.addLine(to: point(157.574, 253.662))
        path.addLine(to: point(660.674, 660.564))
        path.addLine(to: point(255.155, 156.348))
        path.addLine(to: point(669.206, 653.582))
        path.addLine(to: point(369.847, 79.9414))
        path.addLine(to: point(678.936, 648.398))
        path.addLine(to: point(497.241, 27.3779))
        path.addLine(to: point(689.491, 645.212))
        path.addLine(to: point(632.442, 0.67781))
        path.addLine(to: point(700.464, 644.147))
        path.addLine(to: point(770.254, 0.867151))
        path.closeSubpath()
        return path
    }
}
