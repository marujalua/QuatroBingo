//
//  Firestore+Async.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import FirebaseFirestore

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
