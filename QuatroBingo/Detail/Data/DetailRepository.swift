//
//  DetailRepository.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import Dependencies
import FirebaseFirestore

protocol DetailRepository: Actor {
    func retrieveMatch(for id: String, at bingo: String) async throws -> Match
    func retrieveBingo(for id: String) async throws -> IdentifiableModel<Bingo>
    func createMatch(_ match: Match, for id: String, at bingo: String) async throws
    func insertPlayer(_ player: Player, into matchId: String, at bingo: String) async throws
}

actor DetailRepositoryImpl: DetailRepository {
    @Dependency(Firestore.self) private var firebase
    private lazy var decoder: Firestore.Decoder = {
        let d = Firestore.Decoder()
        d.dateDecodingStrategy = .iso8601
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()

    private lazy var encoder: Firestore.Encoder = {
        let e = Firestore.Encoder()
        e.dateEncodingStrategy = .iso8601
        e.keyEncodingStrategy = .convertToSnakeCase
        return e
    }()


    func retrieveMatch(for id: String, at bingo: String) async throws -> Match {
        try await matchReference(for: id, at: bingo)
            .getDocument()
            .data(as: Match.self, decoder: decoder)
    }

    func retrieveBingo(for id: String) async throws -> IdentifiableModel<Bingo> {
        let reference = try await firebase
            .collection(Constants.bingo)
            .document(id)
            .getDocument()

        return IdentifiableModel(id: reference.documentID, model: try reference.data(as: Bingo.self))
    }

    func createMatch(_ match: Match, for id: String, at bingo: String) async throws {
        try await matchReference(for: id, at: bingo)
            .setDataAsync(from: match, merge: false)
    }

    func insertPlayer(_ player: Player, into matchId: String, at bingo: String) async throws {
        var match = try await retrieveMatch(for: matchId, at: bingo)
        match.players.append(player)
        try await createMatch(match, for: matchId, at: bingo)
    }

    private func matchReference(for match: String, at bingo: String) -> DocumentReference {
        firebase
            .collection(Constants.bingo)
            .document(bingo)
            .collection(Constants.matches)
            .document(match)
    }

    enum Constants {
        static var bingo: String { "bingos" }
        static var matches: String { "matches" }
    }

}

enum DetailRepositoryKey: DependencyKey {
    static var liveValue: DetailRepository = DetailRepositoryImpl()
}

struct Match: Codable {
    enum Status: String, Codable {
        case created, running, finished
    }

    struct Log: Codable {
        let value: String
        let time: Date
    }

    var status: Status
    let name: String
    var players: [Player]
    var logs: [Log]
}

struct Player: Codable {
    let id: String
    let name: String
    var score: Int
}

extension DocumentReference {
    func setDataAsync<DataType: Encodable>(
        from data: DataType,
        merge: Bool = true,
        encoder: Firestore.Encoder = .init()
    ) async throws {
        return try await withCheckedThrowingContinuation { completion in
            do {
                try self.setData(from: data, merge: merge, encoder: encoder) { error in
                    if let error {
                        completion.resume(throwing: error)
                    }
                    completion.resume(returning: ())
                }
            } catch let (error) {
                completion.resume(throwing: error)
            }
        }
    }
}
