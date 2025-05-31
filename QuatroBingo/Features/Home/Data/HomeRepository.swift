//
//  HomeRepository.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//
import FirebaseFirestore
import Dependencies

protocol HomeRepository: Actor {
    func fetchAvailableBingo() async throws -> [IdentifiableModel<Bingo>]
}

actor HomeRepositoryImpl: HomeRepository {
    @Dependency(Firestore.self) private var firestore: Firestore

    func fetchAvailableBingo() async throws -> [IdentifiableModel<Bingo>] {
        try await firestore.collection(Constants.bingo).getDocuments().documents.map { snapshot in
            let bingo = try snapshot.data(as: Bingo.self)
            return IdentifiableModel(id: snapshot.documentID, model: bingo)
        }
    }

    enum Constants {
        static var bingo: String { "bingos" }
    }
}

enum HomeRepositoryKey: DependencyKey {
    static var liveValue: HomeRepository = HomeRepositoryImpl()
}
