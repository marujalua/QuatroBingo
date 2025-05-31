//
//  HomeInteractor.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//
import Dependencies

protocol HomeInteractor: Actor {
    func fetchAvailableBingo() async throws -> [BingoViewModel]
}

actor HomeInteractorImpl: HomeInteractor {
    @Dependency(HomeRepositoryKey.self) private var repository

    func fetchAvailableBingo() async throws -> [BingoViewModel] {
        let bingos = try await repository.fetchAvailableBingo()

        return bingos.map { bingo in
            return BingoViewModel(
                id: bingo.id,
                name: bingo.model.name,
                wordsPreview: Array(bingo.model.words.prefix(3)),
                wordCount: bingo.model.words.count
            )
        }
    }
}

enum HomeInteractorKey: DependencyKey {
    static var liveValue: HomeInteractor = HomeInteractorImpl()
}
