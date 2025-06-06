//
//  BingoRepository.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 31/05/25.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import Combine
import Dependencies

protocol BingoRepository: Actor {
    func retrieveBingo(for id: String) async throws -> Bingo
    func watchMatch(bingo: String, match: String) async -> any AsyncSequence<Match, Error>
    func updateMatch(ids: IDs, match: Match) async throws
}

actor BingoRepositoryImpl: BingoRepository {
    @Dependency(Firestore.self) private var firestore
    @Dependency(Firestore.Encoder.self) private var encoder
    @Dependency(Firestore.Decoder.self) private var decoder

    func watchMatch(bingo: String, match: String) async -> any AsyncSequence<Match, Error> {
        firestore
            .collection(Constants.bingo)
            .document(bingo)
            .collection(Constants.matches)
            .document(match)
            .snapshotPublisher()
            .tryMap { document in
                @Dependency(Firestore.Decoder.self) var decoder
                return try document.data(as: Match.self, decoder: decoder)
            }
            .values
    }

    func retrieveBingo(for id: String) async throws -> Bingo {
        let reference = try await firestore
            .collection(Constants.bingo)
            .document(id)
            .getDocument()

        return try reference.data(as: Bingo.self, decoder: decoder)
    }

    func updateMatch(ids: IDs, match: Match) async throws {
        try await firestore
            .collection(Constants.bingo)
            .document(ids.bingo)
            .collection(Constants.matches)
            .document(ids.match)
            .setDataAsync(from: match, encoder: encoder)
    }

    enum Constants {
        static var bingo: String { "bingos" }
        static var matches: String { "matches" }
    }
}

private struct BingoRepositoryKey: DependencyKey {
    static var liveValue: BingoRepository = BingoRepositoryImpl()
}

extension DependencyValues {
    var bingoRepository: BingoRepository {
        get { self[BingoRepositoryKey.self] }
        set { self[BingoRepositoryKey.self] = newValue }
      }
}

