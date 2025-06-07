//
//  ScoreListAdapter.swift
//  QuatroBingo
//
//  Created by Marcos Chevis on 07/06/25.
//

import Foundation

enum ScoreListAdapter {
    static func adapt(adapt data: [String: Player]) -> [ScoreView.ViewData.ScoreItem] {
        let dividerPosition = 3
        var result = data.values.sorted { p1, p2 in
            p1.score > p2.score
        }.enumerated().map { player in
            ScoreView.ViewData.ScoreItem.score(
                .init(
                    id: player.element.id,
                    emoji: player.element.emoji,
                    name: player.element.name,
                    score: player.element.score.formatted(),
                    isHighlighted: player.offset < dividerPosition,
                    place: (player.offset + 1).formatted()
                )
            )
        }
        if result.count >= dividerPosition {
            result.insert(.divider(UUID().uuidString), at: dividerPosition)
        }
        return result
    }
}
